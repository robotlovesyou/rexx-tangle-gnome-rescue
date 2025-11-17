class_name LevelManager
extends Node

var _spawn_point: SpawnPoint

func replace_level_with(path: String) -> void:
	get_tree().change_scene_to_file(path)

func set_active_spawn_point(spawn_point: SpawnPoint) -> void:
	_spawn_point = spawn_point

func spawn_player(player_scene: PackedScene, root: Node, immediate_sibling: Node) -> Player:
	var candidates = get_tree().get_nodes_in_group("Player")
	
	if candidates.size() > 1:
		# This can happen if the player is already spawning this tick
		return
	elif candidates.size() == 1:
		var current_player = candidates[0] as Player
		current_player.queue_free()
		await current_player.tree_exited

	
	var player = player_scene.instantiate()
	root.add_child(player)
	root.move_child(player, immediate_sibling.get_index()+1)
	player.global_position = _spawn_point.global_position
	player.get_camera().make_current()
	return player

func kill_enemy(enemy: CharacterBody2D) -> void:
	enemy.queue_free()
