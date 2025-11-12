class_name PlayerMovementHistory
extends Node

const length_in_seconds: int = 10
var _physics_ticks_per_second
var _length: int
var _history: Array[PlayerMovementData]
var _head: int

func _posmod(a: int, b: int) -> int:
	return ((a % b) + b) % b
	
	
func _duration_to_index(duration: float) -> int:
	return floor(-1.0 * duration * float(_physics_ticks_per_second) + (_head - 1))
	
	
func reset(position: Vector2, state: Enums.Action) -> void:
	_head = 0
	_physics_ticks_per_second = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
	_length = int(_physics_ticks_per_second) * length_in_seconds
	_history.resize(_length)
	_history.fill(PlayerMovementData.new(position, Vector2(), state))

	
func append(position: Vector2, platform_contribution: Vector2, action: Enums.Action, left: bool) -> void:
	_history[_head] = PlayerMovementData.new(position, platform_contribution, action, left)
	_head = _posmod(_head+1, _length)


# returns the data from @offset seconds behind the head	
func at_offset(offset: float) -> PlayerMovementData:
	return _history[_posmod(_duration_to_index(offset), _length)]


# returns the history at a specific index
func at_index(index: int) -> PlayerMovementData:
	return _history[_posmod(_head + index, _length)]
	
	
# returns distance travelled over a duration in seconds
func distance_travelled(duration: float) -> float:
	var target = _duration_to_index(duration)
	var distance = 0.0
	var current = _history[_posmod(_head -1, _length)]
	for index in range(_head -2, target, -1):
		var next = _history[_posmod(index, _length)]
		distance += current.position.distance_to(next.position) - next.platform_contribution.length()
		current = next
	return distance
