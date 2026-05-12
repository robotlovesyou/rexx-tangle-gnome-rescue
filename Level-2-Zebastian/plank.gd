class_name Plank
extends AnimatableBody2D

const MIN_SCALE := 0.1

func _physics_process(delta: float) -> void:
	rotate(delta)
	var scale_x := maxf(MIN_SCALE, abs(cos(global_rotation)))
	$Sprite2D.scale.x = scale_x
	$CollisionShape2D.scale.x = scale_x
