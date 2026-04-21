class_name GlowWorm
extends Node2D

const EPSILON := 0.0001

@export var speed := 10.0
@export var min_energy := 0.5
var _noise := FastNoiseLite.new()
var _t := 0.0

var glow: PointLight2D:
	get: return $Glow


func _ready() -> void:
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
func _curl_noise(at: Vector2) -> Vector2:
	var y_pos = _noise.get_noise_2dv(at + Vector2(0.0, EPSILON))
	var y_neg = _noise.get_noise_2dv(at - Vector2(0.0, EPSILON))
	var d_dy = (y_pos - y_neg) / (2.0 * EPSILON)
	
	var x_pos = _noise.get_noise_2dv(at + Vector2(EPSILON, 0.0))
	var x_neg = _noise.get_noise_2dv(at - Vector2(EPSILON, 0.0))
	var d_dx = (x_pos - x_neg) / (2.0 * EPSILON)
	return Vector2(d_dy, -d_dx)
	
func _physics_process(delta: float) -> void:
	_t += delta
	var curl_noise = _curl_noise(Vector2(_t, _t))
	global_position += curl_noise * speed
	
