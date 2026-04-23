class_name Player
extends CharacterBody2D

signal done_dying

const FRAME_HEIGHT := 32.0 

@export var steps: Array[AudioStreamWAV]
@export var jumps: Array[AudioStreamWAV]
@export var deaths: Array[AudioStreamWAV]
@export var exits: Array[AudioStreamWAV]
@export var skids: Array[AudioStreamWAV]
@export var movement_config: PlayerMovementConfig
@export var debug_is_on_wall_only := false

var _strategy: PlayerStrategy
var _particle_beat_envelope := ADEnvelope.new(0.05, 0.1)
var _min_jump_particle_scale := 0.0
var _max_jump_particle_scale := 0.0
var _t := 0.0
var _cast_wall_normal := Vector2.ZERO

@onready var _walk_effect_player := WalkEffectPlayer.new(walk_player, steps)
@onready var _jump_effect_player := EffectPlayer.new(jump_player, jumps)
@onready var _death_effect_player := EffectPlayer.new(death_player, deaths)
@onready var _exit_effect_player := EffectPlayer.new(exit_player, exits)
@onready var _skid_effect_player := EffectPlayer.new(skid_player, skids)


var wall_jump_timer: Timer:
	get: return $WallJumpTimer

var coyote_jump_timer: Timer:
	get: return $CoyoteJumpTimer

var animated_sprite: AnimatedSprite2D:
	get: return $AnimatedSprite2D

var appear_particles: GPUParticles2D:
	get: return $AppearParticles

var disappear_particles: GPUParticles2D:
	get: return $DisappearParticles

var walk_player: AudioStreamPlayer2D:
	get: return $WalkPlayer

var jump_player: AudioStreamPlayer2D:
	get: return $JumpPlayer

var death_player: AudioStreamPlayer2D:
	get: return $DeathPlayer

var exit_player: AudioStreamPlayer2D:
	get: return $ExitPlayer

var skid_player: AudioStreamPlayer2D:
	get: return $SkidPlayer

var skid_particles: GPUParticles2D:
	get: return $SkidParticles

var jump_particles: GPUParticles2D:
	get: return $CPUJumpParticles

var detect_walls_left_high: RayCast2D:
	get: return $DetectWallsLeftHigh
	
var detect_walls_left_low: RayCast2D:
	get: return $DetectWallsLeftLow
	
var detect_walls_right_high: RayCast2D:
	get: return $DetectWallsRightHigh

var detect_walls_right_low: RayCast2D:
	get: return $DetectWallsRightLow

var debug_rect: ColorRect:
	get: return $DebugRect
	
var anchor_points: Array[Vector2]:
	get: return [_anchor_point_tl.global_position, _anchor_point_tr.global_position, _anchor_point_br.global_position, _anchor_point_bl.global_position]
	
var _anchor_point_tl: Node2D:
	get: return $AnchorPointTL

var _anchor_point_tr: Node2D:
	get: return $AnchorPointTR

var _anchor_point_br: Node2D:
	get: return $AnchorPointBR

var _anchor_point_bl: Node2D:
	get: return $AnchorPointBL
	
var _burn_particles: GPUParticles2D:
	get: return $BurnParticles
	
var _burn_player: AudioStreamPlayer2D:
	get: return $BurnPlayer
	
var _burn_light: PointLight2D:
	get: return $BurnLight

func play_walk() -> void:
	_walk_effect_player.play()

func stop_playing_walk() -> void:
	_walk_effect_player.stop()

func play_jump() -> void:
	_jump_effect_player.play()
	
func start_burn() -> void:
	_burn_player.play()
	create_tween()\
		.tween_property(_burn_light, "energy", 0.0, BurningStrategy.BURN_TIME * 1.5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	_burn_light.enabled = true
	_burn_particles.position.y = FRAME_HEIGHT / 2.0
	_burn_light.position.y = FRAME_HEIGHT / 2.0
	_burn_particles.emitting = true
	_burn_particles.restart()
	
func set_burn_amount(amount: float) -> void:
	amount = min(amount, 1.0)
	_burn_particles.position.y = (FRAME_HEIGHT * (1.0 - amount)) - (FRAME_HEIGHT / 2.0)
	_burn_light.position.y = (FRAME_HEIGHT * (1.0 - amount)) - (FRAME_HEIGHT / 2.0)
	animated_sprite.material.set_shader_parameter("burn_amount", amount)
	
func stop_burn() -> void:
	_burn_particles.emitting = false
	_burn_light.enabled = false
	
func set_hide_amount(amount: float) -> void:
	amount = min(amount, 1.0)
	animated_sprite.material.set_shader_parameter("hide_amount", amount)
	
func set_flame_amount(amount: float) -> void:
	amount = min(amount, 1.0)
	animated_sprite.material.set_shader_parameter("flame_amount", amount)

func play_skid() -> void:
	if not _skid_effect_player.playing:
		_skid_effect_player.play()
		skid_particles.process_material.initial_velocity_min = abs(velocity.x/2.0)
		skid_particles.process_material.initial_velocity_max = abs(velocity.x/2.0)
		skid_particles.process_material.direction.x = sign(velocity.x)
		skid_particles.emitting = true

func stop_skid() -> void:
	skid_particles.emitting = false


func die(reason: Enums.DeathReason) -> void:
	match reason:
		Enums.DeathReason.PIERCED:
			_switch_to_strategy(DyingStrategy.new(self))
			_death_effect_player.play()
		Enums.DeathReason.BURNED:
			_switch_to_strategy(BurningStrategy.new(self))
			
func wait_for_birbs() -> void:
	_switch_to_strategy(WaitingForBirbsStrategy.new(self))
	
func collected_by_birbs() -> void:
	_switch_to_strategy(CarriedByBirbsStrategy.new(self))
	
func deposited_by_birbs() -> void:
	_switch_to_strategy(AliveStrategy.new(self))
	
func caught_in_web(web: SpiderWeb) -> void:
	_switch_to_strategy(WebbedStrategy.new(self, web))
	
func broke_web() -> void:
	_switch_to_strategy(AliveStrategy.new(self))

func exit(exit_scene: Exit) -> void:
	_switch_to_strategy(ExitingStrategy.new(self, exit_scene))
	_exit_effect_player.play()

func exit_done() -> void:
	Events.player_exited_level_sync()

func _ready() -> void:
	_switch_to_strategy(AppearStrategy.new(self))
	_min_jump_particle_scale = jump_particles.scale_amount_min
	_max_jump_particle_scale = jump_particles.scale_amount_max
	Events.beat_channel_1.connect(trigger_beat_effect)
	Events.player_waiting_for_birbs.connect(wait_for_birbs)
	Events.player_collected_by_birbs.connect(collected_by_birbs)
	Events.player_deposited_by_birbs.connect(deposited_by_birbs)
	Events.player_caught_in_web.connect(caught_in_web)
	Events.player_broke_web.connect(broke_web)

func done_appearing() -> void:
	_switch_to_strategy(AliveStrategy.new(self))

func done_disappearing() -> void:
	done_dying.emit()

func _switch_to_strategy(strategy: PlayerStrategy) -> void:
	if _strategy: _strategy.on_exit()
	_strategy = strategy
	_strategy.on_enter()

func _physics_process(delta: float) -> void:
	_t += delta
	_strategy.on_physics_process(delta)
	_strategy.on_animate(animated_sprite)
	_particle_beat_envelope.progress(delta)
	var sample = _particle_beat_envelope.sample()
	jump_particles.scale_amount_max = _max_jump_particle_scale * (1.0 + sample)
	jump_particles.scale_amount_min = _min_jump_particle_scale * (1.0 + sample)

	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider and collider.is_in_group("Projectile"):
			(collider as TurretTrapProjectile).player_collided_with_projectile()
			break

	debug_rect.visible = debug_is_on_wall_only and is_cast_on_wall_only()
	if Input.is_action_just_pressed("burn_baby_burn"):
		Events.player_burned_async()

func is_cast_on_wall_only() -> bool:
	# checking each ray individually to get the wall normal at the same time
	if detect_walls_left_high.is_colliding():
		_cast_wall_normal = detect_walls_left_high.get_collision_normal()
		return true
		
	if detect_walls_left_low.is_colliding():
		_cast_wall_normal = detect_walls_left_low.get_collision_normal()
		return true
		
	if detect_walls_right_high.is_colliding():
		_cast_wall_normal = detect_walls_right_high.get_collision_normal()
		return true
		
	if detect_walls_right_low.is_colliding():
		_cast_wall_normal = detect_walls_right_low.get_collision_normal()
		return true
		
	_cast_wall_normal = Vector2.ZERO
	return false
	
func get_cast_wall_normal() -> Vector2:
	return _cast_wall_normal
		

func get_camera() -> Camera2D:
	return $Camera2D

func trigger_beat_effect() -> void:
	_particle_beat_envelope.trigger()

func _on_walk_player_finished() -> void:
	_walk_effect_player.on_audio_player_finished()
		
	
