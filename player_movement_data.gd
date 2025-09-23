class_name PlayerMovementData
extends RefCounted

var _position: Vector2
var _platform_contribution: Vector2
var _action: Enums.Action
var _left: bool

func _init(init_position: Vector2 = Vector2(), init_platform_contribution: Vector2 = Vector2(), init_action: Enums.Action = Enums.Action.IDLING, init_left: bool  = true) -> void:
	_position = init_position
	_platform_contribution = init_platform_contribution
	_action = init_action
	_left = init_left
	
var position: Vector2:
	get:
		return _position

var platform_contribution: Vector2:
	get:
		return _platform_contribution

var action: Enums.Action:
	get:
		return _action
		
var left: bool:
	get:
		return _left
