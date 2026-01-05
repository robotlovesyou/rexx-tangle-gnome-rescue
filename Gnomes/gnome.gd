class_name Gnome
extends CharacterBody2D


# const SPEED = 300.0
# const JUMP_VELOCITY = -400.0

@export var movement_config: PlayerMovementConfig
@export var hello_sounds: Array[AudioStreamWAV]

@onready var hellos := EffectPlayer.new(hello_player, hello_sounds, {EffectPlayer.MAX_PITCH: 1.0, EffectPlayer.MIN_PITCH: 1.0})

var _action: Enums.GnomeAction
var _player_action: Enums.Action
var _touching_player: bool = false
var _state: GnomeState
var _follow_index: int
var _safe_spot: GnomeSafeSpot
var _has_said_hello := false


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

func _ready() -> void:
	_begin_action(Enums.GnomeAction.GROUNDED)
	_switch_to_state(GnomeWaitState.new(self))
	ActionMonitor.began_action.connect(_player_began_action)

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
			_handle_player_on_platform(_player_action)
		_:
			_handle_gnome_event(Enums.GnomeEvent.PLAYER_STOPPED_IDLING)

func _handle_player_on_platform(player_action: Enums.Action) -> void:
	if _action == Enums.GnomeAction.AIRBORNE:
		_handle_gnome_event(Enums.GnomeEvent.BEGAN_APPROACHING_PLATFORM)
	else:
		pass

func _switch_to_state(state: GnomeState) -> void:
	if _state: _state.on_exit_state()
	if _state: print("%s ==> %s" % [_state.state_name(), state.state_name()])
	_state = state
	_state.on_enter_state()

func _handle_gnome_event(event: Enums.GnomeEvent) -> void:
	match _state.state_id():
		GnomeState.StateID.WAITING:
			match event:
				Enums.GnomeEvent.PLAYER_COLLECTED:
					_switch_to_state(GnomeCollectedState.new(self))
		GnomeState.StateID.COLLECTED:
			match event:
				Enums.GnomeEvent.COLLECTION_DONE:
					_switch_to_state(GnomeLerpFollowState.new(self))
		GnomeState.StateID.LERP_FOLLOW:
			match event:
				Enums.GnomeEvent.LERP_FOLLOW_DONE:
					if _should_enter_stray():
						_switch_to_state(GnomeStrayState.new(self))
					else:
						_switch_to_state(GnomeFollowState.new(self))
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_state(GnomeWanderState.new(self))
				Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_state(GnomeStuckState.new(self))
				Enums.GnomeEvent.BEGAN_APPROACHING_PLATFORM:
					_switch_to_state(GnomePlatformLerpState.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_state(GnomeOrphanedState.new(self))
		GnomeState.StateID.FOLLOW:
			match event:
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_state(GnomeWanderState.new(self))
				Enums.GnomeEvent.BECAME_GROUNDED, Enums.GnomeEvent.PLAYER_COLLECTED, Enums.GnomeEvent.PLAYER_BECAME_IDLE:
					if _should_enter_stray():
						_switch_to_state(GnomeStrayState.new(self))
				Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_state(GnomeStuckState.new(self))
				Enums.GnomeEvent.BEGAN_APPROACHING_PLATFORM:
					_switch_to_state(GnomePlatformLerpState.new(self))
				Enums.GnomeEvent.HIT_SAFE_SPOT:
					if is_on_floor():
						_switch_to_state(GnomeSafeTeleportState.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_state(GnomeOrphanedState.new(self))
		GnomeState.StateID.STRAY:
			match event: 
				Enums.GnomeEvent.PLAYER_STOPPED_IDLING:
					_switch_to_state(GnomeLerpFollowState.new(self))
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_state(GnomeWanderState.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_state(GnomeOrphanedState.new(self))
		GnomeState.StateID.WANDER:
			match event:
				Enums.GnomeEvent.PLAYER_COLLECTED:
					_switch_to_state(GnomeCollectedState.new(self))
		GnomeState.StateID.PLATFORM_LERP:
			match event:
				Enums.GnomeEvent.LANDED_ON_PLATFORM:
					_switch_to_state(GnomePlatformIdleState.new(self))
				Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_state(GnomePlatformStuckState.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_state(GnomeOrphanedState.new(self))
		GnomeState.StateID.PLATFORM_IDLE:
			match event:
				Enums.GnomeEvent.BECAME_ABANDONED:
					_switch_to_state(GnomeWanderState.new(self))
				Enums.GnomeEvent.PLAYER_STOPPED_IDLING:
					_switch_to_state(GnomeLerpFollowState.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_state(GnomeOrphanedState.new(self))
		GnomeState.StateID.PLATFORM_STUCK:
			match event: 
				Enums.GnomeEvent.BECAME_STUCK, Enums.GnomeEvent.BECAME_FREE:
					_switch_to_state(GnomePlatformLerpState.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_state(GnomeOrphanedState.new(self))
		GnomeState.StateID.STUCK:
			match event:
				Enums.GnomeEvent.BECAME_FREE, Enums.GnomeEvent.BECAME_STUCK:
					_switch_to_state(GnomeLerpFollowState.new(self))
				Enums.GnomeEvent.BECAME_ORPHANED:
					_switch_to_state(GnomeOrphanedState.new(self))

func _physics_process(delta: float) -> void:
	_state.on_physics_process(delta)
	_state.on_animate($AnimatedSprite2D)
	if is_on_floor():
		_begin_action(Enums.GnomeAction.GROUNDED)
	else:
		_begin_action(Enums.GnomeAction.AIRBORNE)
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# # Get the input direction and handle the movement/deceleration.
	# # As good practice, you should replace UI actions with custom gameplay actions.
	# var direction := Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)

	# move_and_slide()


func _on_player_collection_body_entered(body:Node2D) -> void:
	if body is Player:
		_touching_player = true
		_handle_gnome_event(Enums.GnomeEvent.PLAYER_COLLECTED)

func _on_player_collection_body_exited(body: Node2D) -> void:
	if body is Player:
		_touching_player = false

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
	return _action == Enums.GnomeAction.GROUNDED and _player_action == Enums.Action.IDLING and _touching_player

func has_player_abandoned() -> float:
	return PMonitor.distance_to(position) > movement_config.MIN_ABANDONED_DISTANCE

func player_abandoned() -> void: 
	_handle_gnome_event(Enums.GnomeEvent.BECAME_ABANDONED)

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
		hellos.play()
		_has_said_hello = true
