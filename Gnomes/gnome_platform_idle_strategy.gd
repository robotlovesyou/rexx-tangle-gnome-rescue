class_name GnomePlatformIdleStrategy
extends GnomeStrategy

var _gnome: Gnome
var _animation_helper: GnomeFollowAnimationHelper
var _phase: float
var _center: float
var _amplitude: float
var _frequency: float
var _growth: float
var _limit: float
var _time: float

func _init(gnome: Gnome, animation_helper: GnomeFollowAnimationHelper = GnomeFollowAnimationHelper.new()):
	_gnome = gnome
	_animation_helper = animation_helper
	_phase = PI
	_center = _gnome.position.x
	_amplitude = _gnome.movement_config.INITIAL_STRAY_AMPLITUDE
	_frequency = _gnome.movement_config.STRAY_OSCILLATION_FREQUENCY
	_growth = _gnome.movement_config.STRAY_GROWTH_RATE_PER_SECOND
	_limit = _gnome.movement_config.STRAY_MAX_WIDTH
	_time = 0.0

func state_id() -> StateID: return StateID.PLATFORM_IDLE

func on_enter_state() -> void:
	pass

func on_physics_process(delta: float) -> void:
	if not _gnome.is_on_floor():
		_gnome.velocity += _gnome.get_gravity() * delta

	_center = MovementHistory.at_offset(0).position.x

	var target_x = _center + (_amplitude * sin(2.0 * PI * _frequency * _time + _phase))
	_time += delta
	_amplitude = min(_limit, _amplitude * (1.0 + (_growth * delta)))
	_gnome.velocity.x = (target_x - _gnome.position.x) * Engine.physics_ticks_per_second
	_gnome.move_and_slide()
	
func on_animate(sprite: AnimatedSprite2D) -> void:
	sprite.play("walk")
