class_name GnomeWanderState
extends GnomeState

var _direction = Vector2.LEFT # todo, randomise this?
var _gnome: Gnome

func _init(gnome: Gnome):
	_gnome = gnome

func state_id() -> StateID: return StateID.WANDER

func on_physics_process(delta: float) -> void:
	if not _gnome.is_on_floor():
		_gnome.velocity += _gnome.get_gravity() * delta

	_gnome.velocity.x = move_toward(_gnome.velocity.x, _gnome.movement_config.SPEED * _direction.x, delta * _gnome.movement_config.ACCELERATION)
	_gnome.move_and_slide()
	if _gnome.is_on_wall():
		print("before ", _direction)
		_direction *= -1.0
		print("after ", _direction)

func on_animate(sprite: AnimatedSprite2D) -> void:
	sprite.flip_h = _direction.x >= 0.0
	if _gnome.is_on_floor():
		sprite.play("walk")
	else:
		sprite.play("jump")
