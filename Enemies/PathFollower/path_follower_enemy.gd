class_name PathFollowerEnemy
extends Enemy

@export var path_follower: PathFollow2D
@export var animated_sprite: AnimatedSprite2D
@export var death_particles: GPUParticles2D

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


func _physics_process(delta: float) -> void:

	match _state:
		State.ALIVE:
			_time_elapsed += delta
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta

			advance_path(_time_elapsed)

			velocity.x = (path_follower.position.x - position.x) * Engine.physics_ticks_per_second
			animated_sprite.flip_h = velocity.x > 0.0

			move_and_slide()
		State.DEAD:
			_time_dead += delta

			# if _time_dead > (DEATH_TIME / 2.0):
			# 	death_particles.emitting = false
			modulate.a = 1.0 - (_time_dead / DEATH_TIME)
			if _time_dead > DEATH_TIME:
				queue_free()

func advance_path(t: float) -> void:
	path_follower.progress_ratio = 0.5 * sin(t) + 0.5

func die() -> void:
	_state = State.DEAD
	collision_layer = 0 # stop colliding with the player
	animated_sprite.play("die")
	death_particles.emitting = true
