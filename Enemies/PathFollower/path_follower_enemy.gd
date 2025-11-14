class_name PathFollowerEnemy
extends CharacterBody2D

@export var path_follower: PathFollow2D
@export var animated_sprite: AnimatedSprite2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var _time_elapsed := 0.0


func _physics_process(delta: float) -> void:

	_time_elapsed += delta

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	advance_path(_time_elapsed)

	velocity.x = (path_follower.position.x - position.x) * Engine.physics_ticks_per_second
	animated_sprite.flip_h = velocity.x > 0.0

	move_and_slide()
	print("%f, %f" % [path_follower.position.x, position.x])

func advance_path(t: float) -> void:
	path_follower.progress_ratio = 0.5 * sin(t) + 0.5
