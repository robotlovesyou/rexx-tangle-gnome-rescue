class_name GnomeStrayStrategy
extends GnomeStrategy

var _gnome: Gnome
var _phase: float
var _center: float
var _amplitude: float
var _frequency: float
var _growth: float
var _limit: float
var _time: float

func _init(gnome: Gnome):
	_gnome = gnome
	_phase = PI
	_center = _gnome.position.x
	_amplitude = _gnome.movement_config.INITIAL_STRAY_AMPLITUDE
	_frequency = _gnome.movement_config.STRAY_OSCILLATION_FREQUENCY
	_growth = _gnome.movement_config.STRAY_GROWTH_RATE_PER_SECOND
	_limit = _gnome.movement_config.STRAY_MAX_WIDTH
	_time = 0.0

func state_id() -> StateID: return StateID.STRAY

func on_enter_state() -> void:
	pass

func on_exit_state() -> void:
	pass

func on_physics_process(delta: float) -> void:
	_gnome.velocity = Vector2.ZERO
	var target_x = _center + (_amplitude * sin(2.0 * PI * _frequency * _time + _phase))
	var target_velocity = (target_x - _gnome.position.x) * Engine.physics_ticks_per_second
	_gnome.move_ghost_to(Vector2(target_x - _gnome.position.x, 0.0))
	if _gnome.ghost_is_standing_on_ground():
		_gnome.velocity.x = target_velocity
		_gnome.move_and_slide()
	
	_gnome.reset_ghost()
	_time += delta
	_amplitude = min(_limit, _amplitude * (1.0 + (_growth * delta)))

func on_animate(sprite: AnimatedSprite2D) -> void:
	sprite.flip_h = _gnome.velocity.x > 0.0
	sprite.play("walk")
