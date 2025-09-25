class_name GnomeFollowAnimationHelper
extends RefCounted

var _last_warned_action: Enums.Action = Enums.Action.NONE


func on_animate(movement_data: PlayerMovementData, sprite: AnimatedSprite2D) -> void:
	sprite.flip_h = movement_data.left
	match movement_data.action:
		Enums.Action.WALKING:
			sprite.play("walk")
		Enums.Action.IDLING:
			sprite.play("idle")
		_:
			if movement_data.action != _last_warned_action:
				_last_warned_action = movement_data.action
				printerr("No animation for action: %s" % Enums.action_name(_last_warned_action))
		
