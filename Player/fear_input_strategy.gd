class_name FearInputStrategy
extends StandardInputStrategy

var _direction := 0.0

func _init(direction: float):
	_direction = direction
	
func get_h_axis() -> float:
	return _direction
