extends Node2D

@export var training_dialogs_layer: TrainingDialogsLayer
@export var enemy_training_dialog: TrainingDialog
@export var player_scene: PackedScene
@export var broken_player_scene: PackedScene
@export var hud: HUD
@export var minimum_gnomes: int
@export var timer_seconds: int
@export var gnome_count_door: Door
@export var timer_door: Door

var _t := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Level.spawn_player(player_scene, self, $Signs)
	MovementHistory.reset($Player.position, Enums.Action.IDLING)
	Events.player_hit_spike_trap.connect(_on_player_hit_spike_trap)
	Events.player_hit_enemy.connect(_on_player_hit_emeny)
	Events.player_killed_enemy.connect(_on_player_killed_enemy)
	hud.update_gnome_count(0, 1, 1)
	hud.update_timer(300)
	hud.hide_gnome_count()
	hud.hide_timer()

func _physics_process(delta: float) -> void:
	_t += delta
	hud.update_timer(timer_seconds - floor(_t))

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


func _on_training_dialog_requested(text: String) -> void:
	training_dialogs_layer.open(text)

func _on_training_dialog_freed(text: String) -> void:
	training_dialogs_layer.close(text)


func _on_training_enemy_died() -> void:
	enemy_training_dialog.active = false

func on_gnome_count_dialog_requested(text: String) -> void:
	hud.show_gnome_count()
	hud.hilight_gnome_count()
	_on_training_dialog_requested(text)


func _on_hud_hilight_gnome_count_done() -> void:
	gnome_count_door.open_door()


func _on_timer_training_dialog_training_dialog_requested(text: String) -> void:
	gnome_count_door.close_door()
	hud.show_timer()
	hud.hilight_timer()
	_on_training_dialog_requested(text)


func _on_hud_hilight_timer_done() -> void:
	timer_door.open_door()
