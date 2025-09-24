class_name GnomeLerpFollowState
extends GnomeState

var _gnome: Gnome
var _lerp_frame_count: float = 0.0
var _animation_helper: GnomeFollowAnimationHelper
var _frame_movement_data: PlayerMovementData

func _init(gnome: Gnome, animation_helper: GnomeFollowAnimationHelper = GnomeFollowAnimationHelper.new()):
	_gnome = gnome
	_animation_helper = animation_helper

func state_id() -> StateID:
	return StateID.LERP_FOLLOW

func on_physics_process(_delta: float) -> void:
	_frame_movement_data = MovementHistory.at_offset(float(_gnome.follow_index) + 1.0 * _gnome.movement_config.OFFSET_PER_INDEX)
	_gnome.position = _gnome.position.lerp(_frame_movement_data.position, _lerp_frame_count / _gnome.movement_config.LERP_FRAME_COUNT)
	_lerp_frame_count += 1.0
	if _lerp_frame_count >= _gnome.movement_config.LERP_FRAME_COUNT:
		_gnome.lerp_follow_complete.call_deferred()

func on_animate(sprite: AnimatedSprite2D) -> void:
	_animation_helper.on_animate(_frame_movement_data, sprite)



