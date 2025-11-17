extends Node2D

@export var initial_dialog: InstructionDialog
@export var player_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_dialog.expand()
	Level.spawn_player(player_scene, self, $Signs)
	MovementHistory.reset($Player.position, Enums.Action.IDLING)
	PMonitor.player = $Player
	Events.player_hit_spike_trap.connect(_on_player_hit_spike_trap)
	Events.player_hit_enemy.connect(_on_player_hit_emeny)
	Events.player_killed_enemy.connect(_on_player_killed_enemy)

func _on_player_hit_spike_trap(_trap: SpikeTrap) -> void:
	Level.spawn_player(player_scene, self, $Signs)

func _on_player_hit_emeny(_enemy: CharacterBody2D) -> void:
	Level.spawn_player(player_scene, self, $Signs)

func _on_player_killed_enemy(enemy: CharacterBody2D) -> void:
	Level.kill_enemy(enemy)
