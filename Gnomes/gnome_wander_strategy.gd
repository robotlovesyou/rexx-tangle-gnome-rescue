class_name GnomeWanderStrategy
extends GnomeStrategy

var _direction = Vector2.LEFT # todo, randomise this?
var _gnome: Gnome
var _speed := 0.0
var _acceleration := 0.0

func _init(gnome: Gnome):
	_gnome = gnome
	_speed = _gnome.movement_config.SPEED * _gnome.movement_config.GNOME_WANDER_SCALE
	_acceleration = _gnome.movement_config.ACCELERATION

func state_id() -> StateID: return StateID.WANDER

func on_enter_state() -> void:
	FollowersMonitor.remove(_gnome)

func on_physics_process(delta: float) -> void:
	if not _gnome.is_on_floor():
		_gnome.velocity += _gnome.get_gravity() * delta

	_gnome.velocity.x = move_toward(_gnome.velocity.x, _speed * _direction.x, delta * _acceleration)
	_gnome.move_and_slide()
	if _gnome.is_on_wall():
		_direction *= -1.0

func on_animate(sprite: AnimatedSprite2D) -> void:
	sprite.flip_h = _direction.x >= 0.0
	if _gnome.is_on_floor():
		sprite.play("walk")
	else:
		pass
