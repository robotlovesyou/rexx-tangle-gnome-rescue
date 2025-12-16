class_name LevelEventBus
extends Node

signal player_hit_spike_trap(SpikeTrap)
signal player_hit_enemy(Enemy)
signal player_killed_enemy(Enemy)
signal player_exited_level()


func player_hit_spike_trap_sync(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit(trap)

func player_hit_spike_trap_async(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit.call_deferred(trap)

func player_hit_enemy_sync(enemy: Enemy) -> void:
	player_hit_enemy.emit(enemy)

func player_hit_enemy_async(enemy: Enemy) -> void:
	player_hit_enemy.emit.call_deferred(enemy)

func player_killed_enemy_sync(enemy: Enemy) -> void:
	player_killed_enemy.emit(enemy)

func player_killed_enemy_async(enemy: Enemy) -> void:
	player_killed_enemy.emit.call_deferred(enemy)

func player_exited_level_sync() -> void:
	player_exited_level.emit()

func player_exited_level_async() -> void:
	player_exited_level.emit.call_deferred()