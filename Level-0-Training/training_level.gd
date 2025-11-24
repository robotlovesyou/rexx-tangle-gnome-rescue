extends Node2D

@export var training_dialogs_layer: TrainingDialogsLayer
@export var enemy_training_dialog: TrainingDialog
@export var player_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Level.spawn_player(player_scene, self, $Signs)
	MovementHistory.reset($Player.position, Enums.Action.IDLING)
	Events.player_hit_spike_trap.connect(_on_player_hit_spike_trap)
	Events.player_hit_enemy.connect(_on_player_hit_emeny)
	Events.player_killed_enemy.connect(_on_player_killed_enemy)

func _on_player_hit_spike_trap(_trap: SpikeTrap) -> void:
	_kill_player()

func _on_player_hit_emeny(_enemy: Enemy) -> void:
	_kill_player()

func _kill_player() -> void:
	await Level.kill_player()
	Level.despawn_player()
	Level.spawn_player(player_scene, self, $Signs)

func _on_player_killed_enemy(enemy: Enemy) -> void:
	Level.kill_enemy(enemy)


func _on_training_dialog_requested(text: String) -> void:
	training_dialogs_layer.open(text)

func _on_training_dialog_freed(text: String) -> void:
	training_dialogs_layer.close(text)


func _on_training_enemy_died() -> void:
	enemy_training_dialog.active = false
