class_name BaseLevel
extends Node2D

@export var player_scene: PackedScene
@export var broken_player_scene: PackedScene
@export var next_level: String
@export var exit: Exit
@export var hud: HUD
@export var minimum_gnomes: int
@export var timer_seconds: int
@export var player_sibling_node: Node


var _rescue_count := 0
var _t := 0.0
var _player_over_exit := false

func _ready() -> void:
	Level.spawn_player(player_scene, self, player_sibling_node)
	MovementHistory.reset($Player.position, Enums.Action.IDLING)
	Events.player_hit_spike_trap.connect(_on_player_hit_spike_trap)
	Events.player_hit_enemy.connect(_on_player_hit_emeny)
	Events.player_killed_enemy.connect(_on_player_killed_enemy)
	Events.player_exited_level.connect(_on_player_exited_level)
	Level.gnome_rescued.connect(_on_gnome_rescued)
	_update_gnome_count_in_hud()
	hud.update_timer(timer_seconds)

func _physics_process(delta: float) -> void:
	_t += delta
	hud.update_timer(timer_seconds - floor(_t))
	if _player_over_exit and Input.is_action_just_pressed("ui_accept"):
		PMonitor.player.exit(exit)


func _on_player_hit_spike_trap(_trap: SpikeTrap) -> void:
	_kill_player()

func _on_player_hit_emeny(_enemy: Enemy) -> void:
	_kill_player()

func _kill_player() -> void:
	Level.spawn_broken_player(PMonitor.player.global_position, broken_player_scene, self, $Signs).set_initial_velocity(PMonitor.player.velocity)
	await Level.kill_player()
	Level.despawn_player()
	Level.spawn_player(player_scene, self, $Signs)

func _on_player_killed_enemy(enemy: Enemy) -> void:
	Level.kill_enemy(enemy)

func _on_player_exited_level() -> void:
	Level.replace_level_with(next_level)

func _on_gnome_rescued() -> void:
	_rescue_count += 1
	await get_tree().create_timer(0).timeout
	_update_gnome_count_in_hud()
	if _rescue_count >= minimum_gnomes:
		exit.active = true

func _update_gnome_count_in_hud() -> void:
	hud.update_gnome_count(_rescue_count, minimum_gnomes, get_tree().get_nodes_in_group("Gnome").size())

func _on_player_entered_exit() -> void:
	_player_over_exit = true


func _on_player_exited_exit() -> void:
	_player_over_exit = false
