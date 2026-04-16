class_name PlayerStrategy
extends RefCounted
var _parent: Player

func _init(parent: Player):
	_parent = parent

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func on_physics_process(delta: float) -> void:
	pass

func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	pass
