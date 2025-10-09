class_name GnomeStuckState
extends GnomeState

var _gnome: Gnome
var _jump_velocity := 0.0
var _elapsed_frames := 0
var _stuck_escape_frames := 0

func _init(gnome: Gnome):
	_gnome = gnome
	_jump_velocity = _gnome.movement_config.JUMP_VELOCITY
	_stuck_escape_frames = _gnome.movement_config.STUCK_ESCAPE_FRAMES
	

func state_id() -> StateID: return StateID.STUCK

func on_enter_state() -> void:
	_gnome.velocity.y += _jump_velocity

func on_physics_process(delta: float) -> void:
	_gnome.velocity += _gnome.get_gravity() * delta
	_gnome.move_and_slide()

	var movement_data = MovementHistory.at_offset(0.0)
	var test_motion = (movement_data.position - _gnome.position) * delta
	if not _gnome.test_move(_gnome.transform, test_motion):
		_gnome.stuck_got_free.call_deferred()
		return

	_elapsed_frames += 1
	if _elapsed_frames >= _stuck_escape_frames:
		_gnome.follow_got_stuck.call_deferred()

	


