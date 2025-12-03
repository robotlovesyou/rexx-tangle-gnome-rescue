class_name Exit
extends Node2D

signal player_entered
signal player_exited

var _active := false
var active: bool:
	get: return _active
	set(value): 
		_active = value
		visible = true
		exit_collision_shape.disabled = false
		

var exit_collision_shape: CollisionShape2D:
	get: return $ExitInteraction/CollisionShape2D

func _ready() -> void:
	visible = false
	exit_collision_shape.disabled = true



func _on_exit_interaction_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited.emit()

func _on_exit_interaction_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()
