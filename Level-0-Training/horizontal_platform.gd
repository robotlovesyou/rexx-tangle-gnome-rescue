class_name HorizontalPlatform
extends Node2D

@export var cycle_time_seconds: float:
	get:
		return 1.0 / _f
	set(value):
		_f = 1.0 / value

@export var path_follow: PathFollow2D
@export var platform: AnimatableBody2D

var _f := 0.1
var _t := 0.0


func _tri(f: float, t: float) -> float: return (2.0/PI) * asin(sin(2.0 * PI * f * t))

func _physics_process(delta: float) -> void:
	_t += delta
	path_follow.progress_ratio = 0.5 * _tri(_f, _t) + 0.5
	platform.position.x = path_follow.position.x
