class_name LevelManager
extends Node

var _spawn_point: SpawnPoint
var spawn_point: SpawnPoint:
	get: return _spawn_point
	set(val): _spawn_point = val

func replace_level_with(path: String) -> void:
	get_tree().change_scene_to_file(path)
