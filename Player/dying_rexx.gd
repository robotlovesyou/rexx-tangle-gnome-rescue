class_name DyingRexx
extends Node2D

const LIFE_TIME_SECONDS := 2.0
var _t := 0.0

func _physics_process(delta: float) -> void:
	_t += delta
	if _t >= LIFE_TIME_SECONDS:
		queue_free()
