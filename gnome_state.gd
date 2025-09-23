class_name GnomeState
extends RefCounted

enum StateID {NONE, WAITING, COLLECTED}

func state_id() -> StateID:
	return StateID.NONE

func on_enter_state() -> void:
	pass

func on_exit_state() -> void:
	pass

func on_physics_process(_delta: float) -> void:
	pass

func on_animate(_sprite: AnimatedSprite2D) -> void:
	pass