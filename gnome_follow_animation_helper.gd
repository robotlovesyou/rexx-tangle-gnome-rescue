class_name GnomeFollowAnimationHelper
extends RefCounted


func on_animate(movement_data: PlayerMovementData, sprite: AnimatedSprite2D) -> void:
	sprite.flip_h = movement_data.left
	match movement_data.action:
		Enums.Action.WALKING:
			sprite.play("walk")
		Enums.Action.IDLING:
			sprite.play("idle")
		_:
			printerr("No animation for action: %s" % Enums.action_name(movement_data.action))
