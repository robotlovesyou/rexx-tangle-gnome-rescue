class_name TurretTrap
extends Node2D

var _max_radians_per_second := 0.0
@export var max_rps: float:
	get: return _max_radians_per_second / 2.0 * PI
	set(value): _max_radians_per_second = value * 2.0 * PI

@export var charge_time_seconds := 3.0
@export var danger_time_seconds := 1.0
@export var barrel_freeze_time := 0.5
@export var projectile_scene: PackedScene
@export var projectile_speed := 100.0
@export var barrel_length := 48.0
@export var auto_visible := true # because it covers a bunch of shit in the editor and I always forget to unhide it...

var _time_charging := 0.0
var _time_in_danger_zone := 0.0
var _time_since_firing := 2.0 * barrel_freeze_time

var _player_in_danger_zone := false
var _player_in_safe_zone := false
var _gnomes_in_safe_zone := 0

var _barrel_pivot: Node2D:
	get: return $BarrelPivot

var _barrel: Sprite2D:
	get: return $BarrelPivot/Barrel

var _firing_player:
	get: return $FiringPlayer

func _on_danger_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_in_danger_zone = false
		_time_in_danger_zone = 0.0


func _on_danger_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_in_danger_zone = true

func _ready() -> void:
	if auto_visible:
		visible = true

func _physics_process(delta: float) -> void:
	_time_since_firing += delta
	_time_charging += delta
	if _player_in_danger_zone:
		_time_in_danger_zone += delta
		if _time_since_firing >= barrel_freeze_time:
			_turn_toward_player(delta)
			
			if _time_charging >= charge_time_seconds and _time_in_danger_zone >= danger_time_seconds and !_player_in_safe_zone and _gnomes_in_safe_zone <= 0:
				_fire_projectile()
				_time_charging = 0.0
				_time_in_danger_zone = 0.0

	_barrel.material.set_shader_parameter("parent_rotation", _barrel_pivot.rotation)

func _turn_toward_player(delta: float):
	var player_position = PMonitor.player.global_position;
	var vector_to_player = player_position - global_position
	var desired_angle = vector_to_player.angle()
	var required_rot = fposmod(desired_angle - _barrel_pivot.rotation + PI, TAU) - PI
	var max_rot = _max_radians_per_second * delta
	if abs(required_rot) > max_rot:
		_barrel_pivot.rotation += sign(required_rot) * max_rot
	else:
		_barrel_pivot.rotation = desired_angle

func _fire_projectile() -> void:
	var projectile = projectile_scene.instantiate() as TurretTrapProjectile
	var vector_down_barrel = Vector2(cos(_barrel_pivot.rotation), sin(_barrel_pivot.rotation))
	projectile.position = vector_down_barrel * barrel_length
	add_child(projectile)
	projectile.projectile_velocity = vector_down_barrel * projectile_speed
	_time_since_firing = 0.0
	_firing_player.play()
	


func _on_safe_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_in_safe_zone = true
	elif body is Gnome:
		_gnomes_in_safe_zone += 1


func _on_safe_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_in_safe_zone = false
	elif body is Gnome:
		_gnomes_in_safe_zone -= 1
