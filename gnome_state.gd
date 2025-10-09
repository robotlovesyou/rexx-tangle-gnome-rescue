class_name GnomeState
extends RefCounted

enum StateID {
	COLLECTED, 
	FOLLOW,
	LERP_FOLLOW, 
	NONE,
	PLATFORM_IDLE,
	PLATFORM_LERP,
	STRAY,
	STUCK,
	WAITING,
	WANDER,
}

func state_id() -> StateID:
	return StateID.NONE

func state_name() -> String: return StateID.find_key(int(state_id()))

func on_enter_state() -> void:
	pass

func on_exit_state() -> void:
	pass

func on_physics_process(_delta: float) -> void:
	pass

func on_animate(_sprite: AnimatedSprite2D) -> void:
	pass