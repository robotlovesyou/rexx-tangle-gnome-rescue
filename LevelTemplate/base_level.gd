class_name BaseLevel
extends Node2D

const CHUNK_DURATION = 1.0/60.1
const GNOME_BURN_TIME = 1.0

@export var player_scene: PackedScene
@export var broken_player_scene: PackedScene
@export var dismembered_gnome_scene: PackedScene
@export var burning_gnome_scene: PackedScene
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
@export var show_gnome_count: bool
@export var show_timer: bool


var _t := 0.0
var _rescue_count := 0
var _current_gnome_count := 0
var _player_over_exit := false
var _beats: Array[float] = []
var _current_beat := 0
var _time_begin := 0.0
var _time_delay := 0.0


func _ready() -> void:
	if show_gnome_count:
		hud.show_gnome_count()
	else:
		hud.hide_gnome_count()
		
	if show_timer:
		hud.show_timer()
	else:
		hud.hide_timer()
		
	_spawn_player(self, player_sibling_node)
	MovementHistory.reset($Player.position, Enums.Action.IDLING)
	FollowersMonitor.reset()
	Events.player_burned.connect(_on_player_burned)
	Events.gnome_burned.connect(_burn_gnome)
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
	Events.gnome_reported_position.connect(hud.report_gnome_location)
	_update_gnome_count_in_hud()
	hud.update_timer(timer_seconds)
	_beats.assign(level_music_beats.data["beats"])
	_time_begin = _time_seconds()
	_time_delay = AudioServer.get_output_latency() + AudioServer.get_time_to_next_mix()
	level_music_player.play()
	hud.set_level_bounds(_find_level_bounds())

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
	
func _time_seconds() -> float:
	return Time.get_ticks_msec() / 1000.0

func _physics_process(delta: float) -> void:
	_t += delta
	var time = _time_seconds() - _time_begin - _time_delay
	if len(_beats) > _current_beat:
		var next_beat = _beats[_current_beat]
		if time >= next_beat:
			_current_beat += 1
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
			
func _on_player_burned() -> void:
	_kill_player(Enums.DeathReason.BURNED)

func _on_player_hit_spike_trap(_trap: SpikeTrap) -> void:
	_kill_player(Enums.DeathReason.PIERCED)

func _on_player_hit_emeny(_enemy: Enemy) -> void:
	_kill_player(Enums.DeathReason.PIERCED)

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
	
func _spawn_burning_gnome(gnome: Gnome) -> BurningGnome:
	print("burning")
	var burning_gnome = burning_gnome_scene.instantiate()
	burning_gnome.global_position = gnome.global_position
	add_child(burning_gnome)
	move_child(burning_gnome, gnome.get_index() + 1)
	return burning_gnome
	

func _on_gnome_hit_spike_trap(_trap: SpikeTrap, gnome: Gnome) -> void:
	_kill_gnome(gnome)

func _kill_player(reason: Enums.DeathReason) -> void:
	if reason == Enums.DeathReason.PIERCED:
		_spawn_broken_player(PMonitor.player.global_position).set_initial_velocity(PMonitor.player.velocity)
		
	PMonitor.player.die(reason)
	await PMonitor.player.done_dying
	_despawn_player()
	_spawn_player(self, player_sibling_node)

func _kill_enemy(enemy: Enemy) -> void:
	enemy.die()

func _on_player_killed_enemy(enemy: Enemy) -> void:
	_kill_enemy(enemy)

func _on_player_exited_level() -> void:
	Level.replace_level_with(next_level)
	
func _dismember_gnome(gnome: Gnome) -> void:
	_spawn_dismembered_gnome(gnome).set_initial_velocity()
	_kill_gnome(gnome)
	
func _burn_gnome(gnome: Gnome) -> void:
	_spawn_burning_gnome(gnome)
	_kill_gnome(gnome)

func _kill_gnome(gnome: Gnome) -> void:
	gnome.die()
	await get_tree().create_timer(0).timeout
	_update_gnome_count_in_hud()
	# This has a race condition. It will be needed for hard mode but it is not currently needed
	#if _current_gnome_count + _rescue_count < minimum_gnomes:
		#game_over(GameOverScreen.Reason.NOT_ENOUGH_GNOMES)

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
	_kill_player(Enums.DeathReason.PIERCED)

func _on_gnome_hit_drop_trap(_trap: DropTrap, gnome: Gnome) -> void:
	_dismember_gnome(gnome)

func _on_player_hit_projectile() -> void:
	_kill_player(Enums.DeathReason.PIERCED)

func _on_gnome_hit_projectile(gnome: Gnome) -> void:
	_dismember_gnome(gnome)
	
func _find_level_bounds() -> Rect2:
	# find all the tilemaps and get their bounds
	# find all the static bodies and get their bounds
	var tl_x := 0
	var tl_y := 0
	var br_x := 0
	var br_y := 0
	for child in find_children("*", "TileMapLayer", true, false):
		var tml = child as TileMapLayer
		var used = tml.get_used_rect()
		var top_left = tml.to_global(tml.map_to_local(used.position))
		var bottom_right = tml.to_global(tml.map_to_local(used.end))
		if top_left.x < tl_x:
			tl_x = top_left.x
		if top_left.y < tl_y:
			tl_y = top_left.y
		if bottom_right.x > br_x:
			br_x = bottom_right.x
		if bottom_right.y > br_y:
			br_y = bottom_right.y
		
	for child in find_children("*", "StaticBody2D", true, false):
		var sb = child as StaticBody2D
		var bounds = _find_static_body_bounds(sb)
		if bounds.position.x < tl_x:
			tl_x = bounds.position.x
		if bounds.position.y < tl_y:
			tl_y = bounds.position.y
		if bounds.end.x > br_x:
			br_x = bounds.end.x
		if bounds.end.y > br_y:
			br_y = bounds.end.y
		
	return Rect2(tl_x, tl_y, br_x - tl_x, br_y - tl_y)
	
func _find_static_body_bounds(sb: StaticBody2D) -> Rect2:
	var bounds = Rect2()
	var first = true
	
	for child in sb.get_children():
		if child is CollisionShape2D and child.shape != null:
			var child_bounds = child.global_transform * child.shape.get_rect()
			if first:
				bounds = child_bounds
				first = false
			else:
				bounds = bounds.merge(child_bounds)
	return bounds
	
