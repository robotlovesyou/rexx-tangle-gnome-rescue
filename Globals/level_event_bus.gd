class_name LevelEventBus
extends Node

signal player_hit_spike_trap(SpikeTrap)
signal player_hit_enemy(CharacterBody2D)
signal player_killed_enemy(CharacterBody2D)


func player_hit_spike_trap_sync(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit(trap)

func player_hit_spike_trap_async(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit.call_deferred(trap)

func player_hit_enemy_sync(enemy: CharacterBody2D) -> void:
	player_hit_enemy.emit(enemy)

func player_hit_enemy_async(enemy: CharacterBody2D) -> void:
	player_hit_enemy.emit.call_deferred(enemy)

func player_killed_enemy_sync(enemy: CharacterBody2D) -> void:
	player_killed_enemy.emit(enemy)

func player_killed_enemy_async(enemy: CharacterBody2D) -> void:
	player_killed_enemy.emit.call_deferred(enemy)





