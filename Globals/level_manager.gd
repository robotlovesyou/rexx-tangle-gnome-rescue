class_name LevelManager
extends Node

var _spawn_point: SpawnPoint

func replace_level_with(path: String) -> void:
	get_tree().change_scene_to_file(path)

func set_active_spawn_point(spawn_point: SpawnPoint) -> void:
	_spawn_point = spawn_point

func despawn_player() -> void:
	if PMonitor.player:
		PMonitor.player.queue_free()
		await PMonitor.player.tree_exited

func spawn_player(player_scene: PackedScene, root: Node, immediate_sibling: Node) -> Player:
	var player = player_scene.instantiate()
	root.add_child(player)
	root.move_child(player, immediate_sibling.get_index()+1)
	player.global_position = _spawn_point.global_position
	player.get_camera().make_current()
	PMonitor.player = player
	return player

func kill_player() -> void:
	PMonitor.player.die()
	await PMonitor.player.done_dying

func kill_enemy(enemy: Enemy) -> void:
	enemy.die()
