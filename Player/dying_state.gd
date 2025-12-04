class_name DyingState
extends PlayerState

const EXIT_STATE_AFTER_SECONDS := 1.0

var _time := 0.0

func on_enter() -> void:
	_parent.visible = false

func on_exit() -> void:
	pass

func on_physics_process(delta: float) -> void:
	_time += delta
	if _time > EXIT_STATE_AFTER_SECONDS:
		_parent.done_disappearing()