class_name MovingPlatform
extends Node2D

@export var travel_time: float = 10.0
var _time: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_time += delta
	$Path2D/PathFollow2D.progress_ratio = abs(sin(2 * PI * (1/travel_time) * _time))
