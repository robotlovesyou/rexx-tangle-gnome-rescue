class_name LevelManager
extends Node

var _spawn_point: SpawnPoint

func replace_level_with(path: String) -> void:
	get_tree().change_scene_to_file(path)

func set_active_spawn_point(spawn_point: SpawnPoint) -> void:
	_spawn_point = spawn_point

func spawn_player(root: Node, immediate_sibling: Node) -> Player:
	var candidates = get_tree().get_nodes_in_group("Player")
	
	if candidates.size() > 1:
		# This can happen if the player is already spawning this tick
		return
	assert(candidates.size() == 1, "Cannot find player")

	var player = candidates[0] as Player
	var path = player.scene_file_path
	player.queue_free()
	var scene = load(path)
	player = scene.instantiate()
	root.add_child(player)
	root.move_child(player, immediate_sibling.get_index()+1)
	player.global_position = _spawn_point.global_position
	player.get_camera().make_current()
	return player
