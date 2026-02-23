class_name BaseLevel
extends Node2D

const CHUNK_DURATION = 1.0/60.1

@export var player_scene: PackedScene
@export var broken_player_scene: PackedScene
@export var dismembered_gnome_scene: PackedScene
@export var next_level: String
@export var exit: Exit
@export var hud: HUD
@export var minimum_gnomes: int
@export var timer_seconds: int
@export var player_sibling_node: Node
@export var level_music_player: AudioStreamPlayer
@export var level_music_beats: JSON
@export var game_over_scene_path: String
@export var mission_successful_scene_path: String
@export var shader_compiler_camera: Camera2D


var _t := 0.0
var _rescue_count := 0
var _current_gnome_count := 0
var _last_chunk_played := 0
var _player_over_exit := false
var _beats: Array[int] = []

func _ready() -> void:
	_spawn_player(self, player_sibling_node)
	# use_all_shaders_and_sfx()
	MovementHistory.reset($Player.position, Enums.Action.IDLING)
	Events.player_hit_spike_trap.connect(_on_player_hit_spike_trap)
	Events.player_hit_enemy.connect(_on_player_hit_emeny)
	Events.player_hit_drop_trap.connect(_on_player_hit_drop_trap)
	Events.player_hit_projectile.connect(_on_player_hit_projectile)
	Events.player_killed_enemy.connect(_on_player_killed_enemy)
	Events.player_exited_level.connect(_on_player_exited_level)
	Events.gnome_hit_spike_trap.connect(_on_gnome_hit_spike_trap)
	Events.gnome_hit_drop_trap.connect(_on_gnome_hit_drop_trap)
	Events.gnome_rescued.connect(_on_gnome_rescued)
	Events.gnome_hit_projectile.connect(_on_gnome_hit_projectile)
	_update_gnome_count_in_hud()
	hud.update_timer(timer_seconds)
	_beats.assign(level_music_beats.data["beats"])
	level_music_player.play()

func _despawn_player() -> void:
	if PMonitor.player:
		PMonitor.player.queue_free()
		await PMonitor.player.tree_exited

func _spawn_player(root: Node, immediate_sibling: Node) -> Player:
	var player = player_scene.instantiate()
	root.add_child(player)
	root.move_child(player, immediate_sibling.get_index()+1)
	player.global_position = Level.spawn_point.global_position
	player.get_camera().make_current()
	PMonitor.player = player
	return player

func _physics_process(delta: float) -> void:
	_t += delta
	var current_chunk = floor(level_music_player.get_playback_position() / CHUNK_DURATION)

	if len(_beats) > current_chunk and _last_chunk_played != current_chunk:
		_last_chunk_played = current_chunk
		if _beats[current_chunk] == 1:
			Events.beat_channel_1_fired_sync()
	
	if timer_seconds - floor(_t) <= 0.0:
		game_over(GameOverScreen.Reason.TIMED_OUT)

	hud.update_timer(timer_seconds - floor(_t))
	if _player_over_exit and Input.is_action_just_pressed("ui_accept"):
		PMonitor.player.exit(exit)

	if Input.is_action_just_released("instakill_gnomes"):
		for item in get_tree().get_nodes_in_group("Gnome"):
			var gnome = item as Gnome
			_kill_gnome(gnome)

func _on_player_hit_spike_trap(_trap: SpikeTrap) -> void:
	_kill_player()

func _on_player_hit_emeny(_enemy: Enemy) -> void:
	_kill_player()

func _spawn_broken_player(at: Vector2) -> BrokenRexx:
	var broken_player = broken_player_scene.instantiate()
	add_child(broken_player)
	move_child(broken_player, player_sibling_node.get_index() + 1)
	broken_player.global_position = at
	return broken_player

func _spawn_dismembered_gnome(gnome: Gnome) -> DismemberedGnome:
	var dismembered_gnome = dismembered_gnome_scene.instantiate()
	dismembered_gnome.global_position = gnome.global_position
	add_child(dismembered_gnome)
	move_child(dismembered_gnome, gnome.get_index() + 1)
	return dismembered_gnome

func _on_gnome_hit_spike_trap(trap: SpikeTrap, gnome: Gnome) -> void:
	_kill_gnome(gnome)

func _kill_player() -> void:
	_spawn_broken_player(PMonitor.player.global_position).set_initial_velocity(PMonitor.player.velocity)
	PMonitor.player.die()
	await PMonitor.player.done_dying
	_despawn_player()
	_spawn_player(self, player_sibling_node)

func _kill_enemy(enemy: Enemy) -> void:
	enemy.die()

func _on_player_killed_enemy(enemy: Enemy) -> void:
	_kill_enemy(enemy)

func _on_player_exited_level() -> void:
	Level.replace_level_with(next_level)

func _kill_gnome(gnome: Gnome) -> void:
	_spawn_dismembered_gnome(gnome).set_initial_velocity()
	gnome.die()
	await get_tree().create_timer(0).timeout
	_update_gnome_count_in_hud()
	if _current_gnome_count + _rescue_count < minimum_gnomes:
		game_over(GameOverScreen.Reason.NOT_ENOUGH_GNOMES)

func game_over(reason: GameOverScreen.Reason) -> void:
	var scene = load(game_over_scene_path)
	var instance = scene.instantiate()
	instance.reason = reason
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(instance)
	get_tree().current_scene = instance

func _on_gnome_rescued(gnome: Gnome) -> void:
	FollowersMonitor.remove(gnome)
	_rescue_count += 1
	await get_tree().create_timer(0).timeout
	_update_gnome_count_in_hud()
	if _rescue_count >= minimum_gnomes:
		exit.active = true

func _update_gnome_count_in_hud() -> void:
	_current_gnome_count = get_tree().get_nodes_in_group("Gnome").size()
	hud.update_gnome_count(_rescue_count, minimum_gnomes, _current_gnome_count)

func _on_player_entered_exit() -> void:
	_player_over_exit = true


func _on_player_exited_exit() -> void:
	_player_over_exit = false

func _on_player_hit_drop_trap(_trap: DropTrap) -> void:
	_kill_player()

func _on_gnome_hit_drop_trap(_trap: DropTrap, gnome: Gnome) -> void:
	_kill_gnome(gnome)

func _on_player_hit_projectile() -> void:
	_kill_player()

func _on_gnome_hit_projectile(gnome: Gnome) -> void:
	_kill_gnome(gnome)
