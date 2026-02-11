@tool
class_name SpawnPoint
extends Node2D

var _active := false
@export var active: bool:
	get: return _active
	set(val): 
		_active = val
		if _active and Engine.is_editor_hint():
			deactivate_other_spawn_points()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _active:
		Level.spawn_point = self

func deactivate_other_spawn_points() -> void:
	if not is_inside_tree():
		return
		
	for point in get_tree().get_nodes_in_group("SpawnPoint"):
		if not point == self:
			(point as SpawnPoint).active = false
