class_name Plank
extends AnimatableBody2D

const MIN_SCALE := 0.1

var width: float:
	get: return $Sprite2D.get_rect().size.x
