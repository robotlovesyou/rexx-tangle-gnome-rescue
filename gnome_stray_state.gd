class_name GnomeStrayState
extends GnomeState

var _gnome: Gnome
var _phase: float
var _center: float
var _amplitude: float
var _frequency: float
var _growth: float
var _time: float

func _init(gnome: Gnome):
	_gnome = gnome

func state_id() -> StateID: return StateID.STRAY

func on_enter_state() -> void:
	_phase = PI
	_center = _gnome.position.x
	_amplitude = _gnome.movement_config.INITIAL_STRAY_AMPLITUDE
	_frequency = _gnome.movement_config.STRAY_OSCILLATION_FREQUENCY
	_growth = _gnome.movement_config.STRAY_GROWTH_RATE_PER_SECOND

func on_physics_process(delta: float) -> void:
	var target_x = _center + (_amplitude * sin(2.0 * PI * _frequency * _time + _phase))
	_time += delta
	_amplitude *= (1.0 + (_growth * delta))
	_gnome.velocity = (Vector2(target_x, _gnome.position.y) - _gnome.position) * Engine.physics_ticks_per_second
	_gnome.move_and_slide()

func on_animate(sprite: AnimatedSprite2D) -> void:
	sprite.flip_h = _gnome.velocity.x > 0.0
	sprite.play("walk")



