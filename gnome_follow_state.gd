class_name GnomeFollowState
extends GnomeState

var _gnome: Gnome
var _animation_helper: GnomeFollowAnimationHelper
var _frame_movement_data: PlayerMovementData

func _init(gnome: Gnome, animation_helper: GnomeFollowAnimationHelper = GnomeFollowAnimationHelper.new()):
	_gnome = gnome
	_animation_helper = animation_helper


func on_physics_process(_delta: float) -> void:
	_frame_movement_data = MovementHistory.at_offset(float(_gnome.follow_index) + 1.0 * _gnome.movement_config.OFFSET_PER_INDEX)
	_gnome.position = _frame_movement_data.position

func on_animate(sprite: AnimatedSprite2D) -> void:
	_animation_helper.on_animate(_frame_movement_data, sprite)