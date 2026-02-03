extends Node2D

var _max_radians_per_second := 0.0
@export var max_rps: float:
	get: return _max_radians_per_second / 2.0 * PI
	set(value): _max_radians_per_second = value * 2.0 * PI

var _player_in_danger_zone := false

var _barrel_pivot: Node2D:
	get: return $BarrelPivot

func _on_danger_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_in_danger_zone = false

func _on_danger_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_in_danger_zone = true

func _ready() -> void:
	print(_max_radians_per_second)

func _physics_process(delta: float) -> void:
	if _player_in_danger_zone:
		_turn_toward_player(delta)

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
