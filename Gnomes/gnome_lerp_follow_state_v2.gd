class_name GnomeLerpFollowStateV2
extends GnomeState

var _gnome: Gnome
var _lerp_frame_count := 0.0
var _lerp_frame_limit  := 0.0
var _animation_helper: GnomeFollowAnimationHelper
var _frame_movement_data: PlayerMovementData
var _offset_per_index := 0.0
#var _stuck_threshold_distance := 0.0

func _init(gnome: Gnome, animation_helper: GnomeFollowAnimationHelper = GnomeFollowAnimationHelper.new()):
	_gnome = gnome
	_animation_helper = animation_helper
	_lerp_frame_limit = (_gnome.follow_index + 1.0) * _gnome.movement_config.LERP_FRAME_COUNT
	_offset_per_index = _gnome.movement_config.OFFSET_PER_INDEX
	#_stuck_threshold_distance = _gnome.movement_config.STUCK_THRESHOLD_DISTANCE

func state_id() -> StateID: return StateID.LERP_FOLLOW

func on_enter_state() -> void:
	_gnome.set_gnome_collision_mask([_gnome.TRAP_ONLY_COLLISION_MASK])
	
func on_exit_state() -> void:
	_gnome.reset_gnome_collision_mask()

func on_physics_process(_delta: float) -> void:
	var _target_offset = (float(_gnome.follow_index) + 1.0) * _offset_per_index
	_frame_movement_data = MovementHistory.at_offset(lerpf(0.0, _target_offset, _lerp_frame_count / _lerp_frame_limit))
	var ideal_velocity = (_frame_movement_data.position - _gnome.position) * Engine.physics_ticks_per_second
	_gnome.velocity = Vector2().lerp(ideal_velocity, _lerp_frame_count / _lerp_frame_limit)
	var _ideal_position = _gnome.position.lerp(_frame_movement_data.position, _lerp_frame_count /_lerp_frame_limit)
	_gnome.move_and_slide()
	_lerp_frame_count += 1.0

	#if _gnome.has_player_abandoned():
		#_gnome.player_abandoned()
		#return

	

	if _lerp_frame_count >= _lerp_frame_limit:
		_gnome.lerp_follow_complete.call_deferred()
	#_gnome.check_stuck(_ideal_position)

func on_animate(sprite: AnimatedSprite2D) -> void:
	_animation_helper.on_animate(_frame_movement_data, sprite)
