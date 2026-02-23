class_name LazerTrap
extends Node2D

const CHARGING_ANIMATION_FRAMES = 9

@export var projectile_scene: PackedScene

@export var charge_time := 2.0

@export var projectile_speed := 100.0

var _next_projectile: TurretTrapProjectile
var _frame := 0
var _player_in_danger_zone := false
var _player_in_safe_zone := false
var _is_charging := false
var _time_charging := 0.0

var _danger_zone: Area2D:
	get: return $DangerZone

var _safe_zone: Area2D:
	get: return $SafeZone

var _body: AnimatedSprite2D:
	get: return $Body

var _firing_player: AudioStreamPlayer2D:
	get: return $FiringPlayer

func _ready():
	assert(projectile_scene != null, "projectile scene must be set")
	_body.animation = "charge"
	_body.frame = 0
	_initialize_danger_zone()
	_initialize_safe_zone()


func _physics_process(delta: float) -> void:
	if _next_projectile == null and _player_in_danger_zone:
		_prepare_next_projectile()

	var charge = 0.0
	if _is_charging:
		_time_charging  += delta
		charge = _time_charging / charge_time
		
	_set_projectile_charge(charge)
	_frame = int(round(charge * float(CHARGING_ANIMATION_FRAMES)))
	_body.frame = _frame

	if _time_charging >= charge_time and !_player_in_safe_zone:
		_fire_projectile()

func _set_projectile_charge(charge: float) -> void:
	if _next_projectile:
		_next_projectile.charge = charge
		

func _prepare_next_projectile() -> void:
	_next_projectile = projectile_scene.instantiate() as TurretTrapProjectile
	add_child(_next_projectile)
	_next_projectile.position = Vector2.ZERO
	_is_charging = true

func _fire_projectile() -> void:
	_firing_player.play()
	var direction = global_position.direction_to(PMonitor.player.global_position)
	_next_projectile.fire(direction * projectile_speed)
	_next_projectile = null
	_is_charging = false
	_time_charging = 0.0



func _player_in_danger() -> void:
	_player_in_danger_zone = true
	_is_charging = true

func _player_out_of_danger() -> void:
	_player_in_danger_zone = false
	_is_charging = false
	_time_charging = 0.0

func _player_in_safe() -> void: 
	_player_in_safe_zone = true

func _player_out_of_safe() -> void:
	_player_in_safe_zone = false

func _initialize_danger_zone() -> void:
	await get_tree().physics_frame
	for body in _danger_zone.get_overlapping_bodies():
		if body is Player:
			_player_in_danger()

func _initialize_safe_zone() -> void:
	await get_tree().physics_frame
	for body in _safe_zone.get_overlapping_bodies():
		if body is Player:
			_player_in_safe()


func _on_danger_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_in_danger()


func _on_danger_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_out_of_danger()


func _on_safe_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_in_safe()


func _on_safe_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_out_of_safe()

