class_name Gnome
extends CharacterBody2D

signal rescued
signal died

const TRAP_ONLY_COLLISION_MASK = 7

@export var movement_config: PlayerMovementConfig
@export var hello_sounds: Array[AudioStreamWAV]
@export var rescue_sounds: Array[AudioStreamWAV]
@export var debug := false


@onready var hellos := EffectPlayer.new(hello_player, hello_sounds, {
	EffectPlayer.MAX_PITCH: 1.2, 
	EffectPlayer.MIN_PITCH: 0.8,
	EffectPlayer.MIN_VOLUME: -3.0,
	EffectPlayer.MAX_VOLUME: 0.0
	})
	
@onready var rescues := EffectPlayer.new(rescue_player, rescue_sounds, {
	EffectPlayer.MAX_PITCH: 1.2, 
	EffectPlayer.MIN_PITCH: 0.8,
	EffectPlayer.MIN_VOLUME: -3.0,
	EffectPlayer.MAX_VOLUME: 0.0
	})

var _action: Enums.GnomeAction
var _player_action: Enums.Action
var _strategy: GnomeStrategy
var _follow_index: int
var _safe_spot: GnomeSafeSpot
var _has_said_hello := false
var _default_collision_mask := 0


var follow_index: int:
	get:
		return _follow_index

var safe_teleport_particles: GPUParticles2D:
	get: return $SafeTeleportParticles

var animated_sprite: AnimatedSprite2D:
	get: return $AnimatedSprite2D

var safe_spot: GnomeSafeSpot:
	get: return _safe_spot

var hello_player: AudioStreamPlayer2D:
	get: return $HelloPlayer
	
var death_player: AudioStreamPlayer2D:
	get: return $DeathPlayer
	
var rescue_player: AudioStreamPlayer2D:
	get: return $RescuePlayer
	
var gnome_speech: AnimatedSprite2D:
	get: return $GnomeSpeech
	
var touching_player_left: RayCast2D:
	get: return $TouchingPlayerLeft
	
var touching_player_right: RayCast2D:
	get: return $TouchingPlayerRight
	
var ghost_standing_on_ground_left: RayCast2D:
	get: return $GhostGnome/StandingOnGroundLeft
	
var ghost_standing_on_ground_right: RayCast2D:
	get: return $GhostGnome/StandingOnGroundRight
	
var ghost_gnome: Node2D:
	get: return $GhostGnome
	
var appear_player: AnimationPlayer:
	get: return $AppearPlayer

func _ready() -> void:
	_default_collision_mask = collision_mask
	_begin_action(Enums.GnomeAction.GROUNDED)
	_switch_to_strategy(GnomeWaitStrategy.new(self))
	ActionMonitor.began_action.connect(_player_began_action)
	
func set_gnome_collision_mask(new_layers: Array[int]) -> void:
	collision_mask = 0
	for layer in new_layers:
		set_collision_mask_value(layer, true)
		
func reset_gnome_collision_mask() -> void:
	collision_mask = _default_collision_mask

func _begin_action(action: Enums.GnomeAction) -> void:
	if action == _action: return
	_action = action
	match _action:
		Enums.GnomeAction.AIRBORNE:
			_handle_gnome_event(Enums.GnomeEvent.BECAME_AIRBORNE)
		Enums.GnomeAction.GROUNDED:
			_handle_gnome_event(Enums.GnomeEvent.BECAME_GROUNDED)

func _player_began_action(action: Enums.Action) -> void:
	_player_action = action
	match _player_action:
		Enums.Action.DYING:
			_handle_gnome_event(Enums.GnomeEvent.BECAME_ORPHANED)
		Enums.Action.IDLING:
			_handle_gnome_event(Enums.GnomeEvent.PLAYER_BECAME_IDLE)
		Enums.Action.PLATFORM_IDLING, Enums.Action.PLATFORM_WALKING:
			_handle_player_on_platform()
		_:
			_handle_gnome_event(Enums.GnomeEvent.PLAYER_STOPPED_IDLING)

func _handle_player_on_platform() -> void:
	if _action == Enums.GnomeAction.AIRBORNE:
		_handle_gnome_event(Enums.GnomeEvent.BEGAN_APPROACHING_PLATFORM)
	else:
		pass

func _switch_to_strategy(strategy: GnomeStrategy) -> void:
	if _strategy: _strategy.on_exit_state()
	if _strategy: print("%s ==> %s" % [_strategy.state_name(), strategy.state_name()])
	_strategy = strategy
	_strategy.on_enter_state()

func _handle_gnome_event(event: Enums.GnomeEvent) -> void:
	match _strategy.state_id():
		GnomeStrategy.StateID.WAITING:
			match event:
				Enums.GnomeEvent.PLAYER_COLLECTED:
					_switch_to_strategy(GnomeCollectedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.COLLECTED:
			match event:
				Enums.GnomeEvent.COLLECTION_DONE:
					_switch_to_strategy(GnomeLerpFollowStrategyV2.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.LERP_FOLLOW:
			match event:
				Enums.GnomeEvent.LERP_FOLLOW_DONE:
					if _should_enter_stray():
						_switch_to_strategy(GnomeStrayStrategy.new(self))
					else:
						_switch_to_strategy(GnomeFollowStrategyV2.new(self))
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_strategy(GnomeWanderStrategy.new(self))
				Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_strategy(GnomeStuckStrategy.new(self))
				Enums.GnomeEvent.BEGAN_APPROACHING_PLATFORM:
					_switch_to_strategy(GnomePlatformLerpStrategy.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_strategy(GnomeOrphanedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
				Enums.GnomeEvent.HIT_SAFE_SPOT:
					_switch_to_strategy(GnomeSafeTeleportStrategy.new(self))
		GnomeStrategy.StateID.FOLLOW:
			match event:
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_strategy(GnomeWanderStrategy.new(self))
				Enums.GnomeEvent.BECAME_GROUNDED, Enums.GnomeEvent.PLAYER_COLLECTED, Enums.GnomeEvent.PLAYER_BECAME_IDLE:
					print("should I stray?")
					if _should_enter_stray():
						print("yes, I should")
						_switch_to_strategy(GnomeStrayStrategy.new(self))
				Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_strategy(GnomeStuckStrategy.new(self))
				Enums.GnomeEvent.BEGAN_APPROACHING_PLATFORM:
					_switch_to_strategy(GnomePlatformLerpStrategy.new(self))
				Enums.GnomeEvent.HIT_SAFE_SPOT:
					_switch_to_strategy(GnomeSafeTeleportStrategy.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_strategy(GnomeOrphanedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.STRAY:
			match event: 
				Enums.GnomeEvent.PLAYER_STOPPED_IDLING:
					_switch_to_strategy(GnomeLerpFollowStrategyV2.new(self))
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_strategy(GnomeWanderStrategy.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_strategy(GnomeOrphanedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.WANDER:
			match event:
				Enums.GnomeEvent.PLAYER_COLLECTED:
					_switch_to_strategy(GnomeCollectedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.PLATFORM_LERP:
			match event:
				Enums.GnomeEvent.LANDED_ON_PLATFORM:
					_switch_to_strategy(GnomePlatformIdleStrategy.new(self))
				Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_strategy(GnomePlatformStuckStrategy.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_strategy(GnomeOrphanedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.PLATFORM_IDLE:
			match event:
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_strategy(GnomeWanderStrategy.new(self))
				Enums.GnomeEvent.PLAYER_STOPPED_IDLING:
					_switch_to_strategy(GnomeLerpFollowStrategyV2.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_strategy(GnomeOrphanedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.PLATFORM_STUCK:
			match event: 
				Enums.GnomeEvent.BECAME_STUCK, Enums.GnomeEvent.BECAME_FREE:
					_switch_to_strategy(GnomePlatformLerpStrategy.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_strategy(GnomeOrphanedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.STUCK:
			match event:
				Enums.GnomeEvent.BECAME_FREE, Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_strategy(GnomeLerpFollowStrategyV2.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_strategy(GnomeOrphanedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))
		GnomeStrategy.StateID.ORPHANED:
			match event: 
				Enums.GnomeEvent.PLAYER_COLLECTED:
					_switch_to_strategy(GnomeCollectedStrategy.new(self))
				Enums.GnomeEvent.DIED:
					_switch_to_strategy(GnomeDyingStrategy.new(self))

func _physics_process(delta: float) -> void:
	_strategy.on_physics_process(delta)
	_strategy.on_animate($AnimatedSprite2D)
	if ghost_is_standing_on_ground():
		_begin_action(Enums.GnomeAction.GROUNDED)
	else:
		_begin_action(Enums.GnomeAction.AIRBORNE)

	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("Projectile"):
			(collider as TurretTrapProjectile).gnome_collided_with_projectile(self)
			break
			
	Events.gnome_reported_position_sync(get_instance_id(), global_position)

func _on_player_collection_body_entered(body:Node2D) -> void:
	if body is Player:
		_handle_gnome_event(Enums.GnomeEvent.PLAYER_COLLECTED)

func _on_player_collection_body_exited(_body: Node2D) -> void:
	pass

func collection_complete(index: int) -> void:
	_follow_index = index
	_handle_gnome_event(Enums.GnomeEvent.COLLECTION_DONE)

func follow_got_stuck() -> void:
	_handle_gnome_event(Enums.GnomeEvent.BECAME_STUCK)

func follow_not_stuck() -> void:
	pass

func lerp_follow_complete():
	_handle_gnome_event(Enums.GnomeEvent.LERP_FOLLOW_DONE)

func platform_lerp_follow_complete():
	_handle_gnome_event(Enums.GnomeEvent.LANDED_ON_PLATFORM)

func _should_enter_stray() -> bool:
	print("%s, %s, %s" % [Enums.gnome_action_name(_action), Enums.action_name(_player_action), _is_touching_player()])
	return _action == Enums.GnomeAction.GROUNDED and _player_action == Enums.Action.IDLING and _is_touching_player()

#func has_player_abandoned() -> float:
	#return PMonitor.distance_to(position) > movement_config.MIN_ABANDONED_DISTANCE

#func player_abandoned() -> void: 
	#_handle_gnome_event(Enums.GnomeEvent.BECAME_ABANDONED)

func stuck_got_free():
	_handle_gnome_event(Enums.GnomeEvent.BECAME_FREE)

func hit_safe_spot(safe_spot_hit: GnomeSafeSpot) -> void:
	_safe_spot = safe_spot_hit
	_handle_gnome_event(Enums.GnomeEvent.HIT_SAFE_SPOT)

func move_behind_safe_spot() -> void:
	# Assumes that the safe spot and the gnome have the same parent. 
	get_parent().move_child(self, _safe_spot.get_index())

func check_stuck(expected_position: Vector2) -> void:
	if position.distance_to(expected_position) > movement_config.STUCK_THRESHOLD_DISTANCE:
		follow_got_stuck.call_deferred()
	else:
		follow_not_stuck()

func play_hello_once() -> void:
	if !_has_said_hello:
		gnome_speech.show()
		hellos.play()
		_has_said_hello = true
		
func play_rescue() -> void:
	rescues.play()

func die() -> void:
	_handle_gnome_event(Enums.GnomeEvent.DIED)
	
func gnome_has_died() -> void:
	died.emit()

func _on_hello_player_finished() -> void:
	gnome_speech.hide()
	
func _is_touching_player() -> bool:
	return touching_player_left.is_colliding() or touching_player_right.is_colliding()
	
func ghost_is_standing_on_ground() -> bool:
	ghost_standing_on_ground_left.force_raycast_update()
	ghost_standing_on_ground_right.force_raycast_update()
	var on_ground = ghost_standing_on_ground_left.is_colliding() and ghost_standing_on_ground_right.is_colliding()
	if on_ground:
		$GhostGnome/ColorRect.color = Color.WHITE
	else:
		$GhostGnome/ColorRect.color = Color.RED
	return on_ground
	
func reset_ghost() -> void:
	ghost_gnome.position = Vector2.ZERO
	#if debug:
		#print("%s, %s, %s" % [position, ghost_gnome.position, ghost_is_standing_on_ground()])
	
func move_ghost_to(to: Vector2) -> void:
	ghost_gnome.position = to
	#if debug:
		#print("%s, %s, %s" % [position, ghost_gnome.position, ghost_is_standing_on_ground()])
		
func gnome_was_rescued() -> void:
	rescued.emit()
	
func prepare_appear() -> void:
	animated_sprite.material.set_shader_parameter("amount", 0.0)
	
func appear() -> void:
	appear_player.play("appear")
