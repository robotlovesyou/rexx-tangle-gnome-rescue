class_name PathFollowerGhost
extends Enemy

signal died

@export var path_follower: PathFollow2D
@export var sprite: Sprite2D
@export var death_particles: GPUParticles2D
@export var death_sounds: Array[AudioStreamWAV]
@export var number_of_waves := 2.5
@export var offset_scale := 0.01

@onready var death_player := EffectPlayer.new(spark_player, death_sounds)

enum State {
	ALIVE,
	DEAD
}

var _state := State.ALIVE

const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const DEATH_TIME := 1.0

var _time_elapsed := 0.0
var _time_dead := 0.0

var spark_player: AudioStreamPlayer2D:
	get: return $SparkPlayer
	
func _ready() -> void:
	sprite.material.set_shader_parameter("n_cycles", number_of_waves)
	sprite.material.set_shader_parameter("offset_scale", offset_scale)
	
func _physics_process(delta: float) -> void:

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

func die() -> void:
	_state = State.DEAD
	collision_layer = 0 # stop colliding with the player
	death_player.play()
	death_particles.restart()
	died.emit()
