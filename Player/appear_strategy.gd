class_name AppearStrategy
extends PlayerStrategy

const EXIT_STATE_AFTER_SECONDS := 1.0
const PARTICLES_INITIAL_Y = -12
const PARTICLES_FINAL_Y = 15

var _time := 0.0

func on_enter() -> void:
	_parent.animated_sprite.flip_h = true
	_parent.animated_sprite.play("appear")
	_parent.appear_particles.emitting = true
	_parent.appear_particles.position.y = PARTICLES_INITIAL_Y

func on_exit() -> void:
	_parent.appear_particles.emitting = false

func on_physics_process(delta: float) -> void:
	_time += delta
	_parent.appear_particles.position.y = (PARTICLES_FINAL_Y - PARTICLES_INITIAL_Y) * (_time / EXIT_STATE_AFTER_SECONDS) + PARTICLES_INITIAL_Y
	_parent.velocity += _parent.get_gravity() * delta
	_parent.move_and_slide()
	if _time > EXIT_STATE_AFTER_SECONDS:
		_parent.done_appearing()
