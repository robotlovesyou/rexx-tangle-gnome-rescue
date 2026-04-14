class_name WaitingForBirbsState
extends PlayerState

func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.play("idle")
