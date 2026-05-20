extends Node2D

@export var lights: Array[PointLight2D]
@export var cycle_time_seconds := 1.0

var _t := 0.0

func _physics_process(delta: float) -> void:
	_t = fmod(_t + delta, cycle_time_seconds)
	
	var active = roundf(_t * lights.size())
	for i in range(lights.size()):
		lights[i].enabled = i == active
