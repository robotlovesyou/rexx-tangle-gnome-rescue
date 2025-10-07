class_name GnomeFollowState
extends GnomeState

var _gnome: Gnome
var _animation_helper: GnomeFollowAnimationHelper
var _frame_movement_data: PlayerMovementData

func _init(gnome: Gnome, animation_helper: GnomeFollowAnimationHelper = GnomeFollowAnimationHelper.new()):
	_gnome = gnome
	_animation_helper = animation_helper

func state_id() -> StateID: return StateID.FOLLOW

func on_physics_process(_delta: float) -> void:
	_frame_movement_data = MovementHistory.at_offset((float(_gnome.follow_index) + 1.0) * _gnome.movement_config.OFFSET_PER_INDEX)
	_gnome.velocity = (_frame_movement_data.position - _gnome.position) * Engine.physics_ticks_per_second
	_gnome.move_and_slide()
	# distance between where we ended up and where we wanted to be. use to check if gnome is stuck
	if _gnome.position.distance_to(_frame_movement_data.position) > _gnome.movement_config.STUCK_THRESHOLD_DISTANCE:
		_gnome.follow_got_stuck.call_deferred()
	else:
		_gnome.follow_not_stuck()

func on_animate(sprite: AnimatedSprite2D) -> void:
	_animation_helper.on_animate(_frame_movement_data, sprite)