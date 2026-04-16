class_name GnomeFollowStrategyV2
extends GnomeStrategy


var _gnome: Gnome
var _animation_helper: GnomeFollowAnimationHelper
var _frame_movement_data: PlayerMovementData

func _init(gnome: Gnome, animation_helper: GnomeFollowAnimationHelper = GnomeFollowAnimationHelper.new()):
	_gnome = gnome
	_animation_helper = animation_helper

func state_id() -> StateID: return StateID.FOLLOW

func on_enter_state() -> void:
	_gnome.set_gnome_collision_mask([_gnome.TRAP_ONLY_COLLISION_MASK])
	
func on_exit_state() -> void:
	_gnome.reset_gnome_collision_mask()

func on_physics_process(_delta: float) -> void:
	_frame_movement_data = MovementHistory.at_offset((float(_gnome.follow_index) + 1.0) * _gnome.movement_config.OFFSET_PER_INDEX)
	_gnome.velocity = (_frame_movement_data.position - _gnome.position) * Engine.physics_ticks_per_second
	_gnome.move_and_slide()

func on_animate(sprite: AnimatedSprite2D) -> void:
	_animation_helper.on_animate(_frame_movement_data, sprite)
