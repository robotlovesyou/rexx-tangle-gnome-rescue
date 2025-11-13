class_name LevelEventBus
extends Node

signal player_hit_spike_trap(SpikeTrap)


func player_hit_spike_trap_sync(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit(trap)

func player_hit_spike_trap_async(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit.call_deferred(trap)



