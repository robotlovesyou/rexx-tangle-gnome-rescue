class_name Plank
extends AnimatableBody2D

const MIN_SCALE := 0.1

var width: float:
	get: return $Sprite2D.get_rect().size.x
	
var frame_velocity := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	move_and_collide(frame_velocity)
