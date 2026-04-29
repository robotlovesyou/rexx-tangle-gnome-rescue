class_name PathFollowerGhost
extends Enemy

@export var path_follower: PathFollow2D
@export var sprite: Sprite2D
@export var number_of_waves := 2.5
@export var offset_scale := 0.01

var _t := 0.0
var _state := State.ALIVE
var _pitch_noise: FastNoiseLite

const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const DEATH_TIME := 1.0
const PITCH_NOISE_FREQUENCY := 0.5

var _time_elapsed := 0.0
var _time_dead := 0.0
	
var ghostly_sound_player: AudioStreamPlayer2D:
	get: return $GhostlySoundPlayer
	
func _ready() -> void:
	_pitch_noise = FastNoiseLite.new()
	_pitch_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_pitch_noise.frequency = PITCH_NOISE_FREQUENCY
	ghostly_sound_player.play()
	sprite.material.set_shader_parameter("n_cycles", number_of_waves)
	sprite.material.set_shader_parameter("offset_scale", offset_scale)
	
func _physics_process(delta: float) -> void:
	_t += delta
	var pitch_mod = _pitch_noise.get_noise_1d(_t) * 0.5
	ghostly_sound_player.pitch_scale = 1.0 + pitch_mod

	match _state:
		State.ALIVE:
			_time_elapsed += delta
			advance_path(_time_elapsed)
			velocity.x = (path_follower.position.x - position.x) * Engine.physics_ticks_per_second
			move_and_slide()
		State.DEAD:
			_time_dead += delta
			modulate.a = 1.0 - (_time_dead / DEATH_TIME)
			if _time_dead > DEATH_TIME:
				queue_free()

func advance_path(t: float) -> void:
	path_follower.progress_ratio = 0.5 * sin(t) + 0.5
