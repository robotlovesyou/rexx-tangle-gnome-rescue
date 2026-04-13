class_name LevelEventBus
extends Node

signal player_hit_spike_trap(SpikeTrap)
signal gnome_hit_spike_trap(SpikeTrap, Gnome)
signal player_hit_drop_trap(DropTrap)
signal gnome_hit_drop_trap(DropTrap, Gnome)
signal player_hit_projectile()
signal gnome_hit_projectile(Gnome)
signal gnome_rescued(Gnome)
signal player_hit_enemy(Enemy)
signal player_killed_enemy(Enemy)
signal player_exited_level()
signal beat_channel_1
signal gnome_reported_position(id: int, position: Vector2)
signal player_waiting_for_birbs
signal player_collected_by_birbs
signal birbs_moved_player(position: Vector2)
signal player_deposited_by_birbs

func player_hit_spike_trap_sync(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit(trap)

func player_hit_spike_trap_async(trap: SpikeTrap) -> void:
	player_hit_spike_trap.emit.call_deferred(trap)

func gnome_hit_spike_trap_sync(trap: SpikeTrap, gnome: Gnome) -> void:
	gnome_hit_spike_trap.emit(trap, gnome)

func gnome_hit_spike_trap_async(trap: SpikeTrap, gnome: Gnome) -> void:
	gnome_hit_spike_trap.emit.call_deferred(trap, gnome)

func player_hit_drop_trap_sync(trap: DropTrap) -> void:
	player_hit_drop_trap.emit(trap)

func player_hit_drop_trap_async(trap: DropTrap) -> void:
	player_hit_drop_trap.emit.call_deferred(trap)

func gnome_hit_drop_trap_sync(trap: DropTrap, gnome: Gnome) -> void:
	gnome_hit_drop_trap.emit(trap, gnome)

func gnome_hit_drop_trap_async(trap: DropTrap, gnome: Gnome) -> void:
	gnome_hit_drop_trap.emit.call_deferred(trap, gnome)

func gnome_rescued_sync(gnome: Gnome) -> void:
	gnome_rescued.emit(gnome)

func gnome_rescued_async(gnome: Gnome) -> void:
	gnome_rescued.emit.call_deferred(gnome)

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

func beat_channel_1_fired_sync() -> void:
	beat_channel_1.emit()

func beat_channel_1_fired_async() -> void:
	beat_channel_1.emit.call_deferred()

func player_hit_projectile_sync() -> void:
	player_hit_projectile.emit()

func player_hit_projectile_async() -> void:
	player_hit_projectile.emit.call_deferred()

func gnome_hit_projectile_sync(gnome: Gnome) -> void:
	gnome_hit_projectile.emit(gnome)

func gnome_hit_projectile_async(gnome: Gnome) -> void:
	gnome_hit_projectile.emit.call_deferred(gnome)
	
func gnome_reported_position_sync(id: int, position: Vector2) -> void:
	gnome_reported_position.emit(id, position)
	
func gnome_reported_position_async(id: int, position: Vector2) -> void:
	gnome_reported_position.emit.call_deferred(id, position)
	
func player_waiting_for_birbs_sync():
	player_waiting_for_birbs.emit()
	
func player_waiting_for_birbs_async():
	player_waiting_for_birbs.emit.call_deferred()
	
func player_collected_by_birbs_sync():
	player_collected_by_birbs.emit()
	
func player_collected_by_birbs_async():
	player_collected_by_birbs.emit.call_deferred()
	
func birbs_moved_player_sync(to: Vector2):
	birbs_moved_player.emit(to)
	
func birbs_moved_player_async(to: Vector2):
	birbs_moved_player.emit.call_deferred(to)
	
func player_deposited_by_birbs_sync():
	player_deposited_by_birbs.emit()
	
func player_deposited_by_birbs_async():
	player_deposited_by_birbs.emit.call_deferred()
