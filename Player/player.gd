class_name Player
extends CharacterBody2D

signal done_dying

@export var steps: Array[AudioStreamWAV]
@export var jumps: Array[AudioStreamWAV]
@export var deaths: Array[AudioStreamWAV]
@export var exits: Array[AudioStreamWAV]
@export var skids: Array[AudioStreamWAV]
@export var movement_config: PlayerMovementConfig
@export var debug_is_on_wall_only := false

var _state: PlayerState
var _particle_beat_envelope := ADEnvelope.new(0.05, 0.1)
var _min_jump_particle_scale := 0.0
var _max_jump_particle_scale := 0.0
var _t := 0.0

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

var detect_walls_left: RayCast2D:
	get: return $DetectWallsLeft

var detect_walls_right: RayCast2D:
	get: return $DetectWallsRight

var debug_rect: ColorRect:
	get: return $DebugRect

func play_walk() -> void:
	_walk_effect_player.play()

func stop_playing_walk() -> void:
	_walk_effect_player.stop()

func play_jump() -> void:
	_jump_effect_player.play()

func play_skid() -> void:
	if not _skid_effect_player.playing:
		_skid_effect_player.play()
		skid_particles.process_material.initial_velocity_min = abs(velocity.x/2.0)
		skid_particles.process_material.initial_velocity_max = abs(velocity.x/2.0)
		skid_particles.process_material.direction.x = sign(velocity.x)
		skid_particles.emitting = true

func stop_skid() -> void:
	skid_particles.emitting = false


func die() -> void:
	_switch_to_state(DyingState.new(self))
	_death_effect_player.play()

func exit(exit_scene: Exit) -> void:
	_switch_to_state(ExitingState.new(self, exit_scene))
	_exit_effect_player.play()

func exit_done() -> void:
	Events.player_exited_level_sync()

func _ready() -> void:
	_switch_to_state(AppearState.new(self))
	_min_jump_particle_scale = jump_particles.scale_amount_min
	_max_jump_particle_scale = jump_particles.scale_amount_max
	Events.beat_channel_1.connect(trigger_beat_effect)

func done_appearing() -> void:
	_switch_to_state(AliveState.new(self))

func done_disappearing() -> void:
	done_dying.emit()

func _switch_to_state(state: PlayerState) -> void:
	if _state: _state.on_exit()
	_state = state
	_state.on_enter()

func _physics_process(delta: float) -> void:
	_t += delta
	_state.on_physics_process(delta)
	_state.on_animate(animated_sprite)
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

func is_cast_on_wall_only() -> bool:
	return (detect_walls_left.is_colliding() or detect_walls_right.is_colliding()) and !is_on_floor()
		

func get_camera() -> Camera2D:
	return $Camera2D

func trigger_beat_effect() -> void:
	_particle_beat_envelope.trigger()

func _on_walk_player_finished() -> void:
	_walk_effect_player.on_audio_player_finished()
