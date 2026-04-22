class_name WaitingForBirbsStrategy
extends PlayerStrategy

func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.play("idle")
