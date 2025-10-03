class_name GnomePlatformLerpState
extends GnomeState

var _gnome: Gnome

var _state_frame_count: float = 0.0
var _lerp_frame_count: float
var _animation_helper: GnomeFollowAnimationHelper
var _frame_movement_data: PlayerMovementData

func _init(gnome: Gnome, animation_helper: GnomeFollowAnimationHelper = GnomeFollowAnimationHelper.new()):
	_gnome = gnome
	_animation_helper = animation_helper
	_lerp_frame_count = _gnome.movement_config.LERP_FRAME_COUNT

func state_id() -> StateID: return StateID.PLATFORM_LERP

func on_physics_process(_delta: float) -> void:
	_frame_movement_data = MovementHistory.at_offset(0.0)
	var ideal_velocity = (_frame_movement_data.position - _gnome.position) * Engine.physics_ticks_per_second
	_gnome.velocity = Vector2().lerp(ideal_velocity, _state_frame_count / _lerp_frame_count)
	_gnome.move_and_slide()
	_state_frame_count += 1.0
	if _state_frame_count >= _lerp_frame_count:
		_gnome.platform_lerp_follow_complete()