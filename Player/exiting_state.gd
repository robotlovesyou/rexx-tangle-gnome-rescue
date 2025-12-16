class_name ExitingState
extends PlayerState

const EXIT_TIME_SECONDS := 3.0
const ROTATIONS_PER_SECOND = 3.0

var _exit: Exit
var _t := 0.0

func _init(parent: Player, exit: Exit):
	super(parent)
	_exit = exit

func on_enter() -> void:
	_parent.velocity = (_exit.center - _parent.position) / EXIT_TIME_SECONDS

func on_physics_process(delta: float) -> void:
	_t += delta
	_parent.rotation = _t * 2 * PI * ROTATIONS_PER_SECOND
	_parent.scale = Vector2(1.0, 1.0).lerp(Vector2(0.0, 0.0), _t / EXIT_TIME_SECONDS)
	_parent.move_and_slide()
	if _t > EXIT_TIME_SECONDS:
		_parent.exit_done()