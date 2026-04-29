class_name GlowWorm
extends Node2D

const EPSILON := 0.0001

@export var speed := 50.0
@export var max_range := 100.0
var _noise: FastNoiseLite
var _t := 0.0

var glow_green: PointLight2D:
	get: return $Worm/GlowGreen
	
var glow_blue: PointLight2D:
	get: return $Worm/GlowBlue
	
var body_green: ColorRect:
	get: return $Worm/BodyGreen
	
var body_blue: ColorRect:
	get: return $Worm/BodyBlue
	
var worm: Node2D:
	get: return $Worm

func _ready() -> void:
	_noise = FastNoiseLite.new()
	_noise.seed = randi_range(-1000,1000)
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	worm.position = Vector2(randf_range(-max_range/2.0, max_range/2.0), randf_range(-max_range/2.0, max_range/2.0))
	if randf() >=0.5:
		glow_green.enabled = false
		glow_green.hide()
		body_green.hide()
	else:
		glow_blue.enabled = false
		glow_blue.hide()
		body_blue.hide()
	
	
func _curl_noise(at: Vector2) -> Vector2:
	var y_pos = _noise.get_noise_2dv(at + Vector2(0.0, EPSILON))
	var y_neg = _noise.get_noise_2dv(at - Vector2(0.0, EPSILON))
	var d_dy = (y_pos - y_neg) / (2.0 * EPSILON)
	
	var x_pos = _noise.get_noise_2dv(at + Vector2(EPSILON, 0.0))
	var x_neg = _noise.get_noise_2dv(at - Vector2(EPSILON, 0.0))
	var d_dx = (x_pos - x_neg) / (2.0 * EPSILON)
	return Vector2(d_dy, -d_dx)
	
func _calculate_outward_component(m: Vector2) -> Vector2:
	if worm.position == Vector2.ZERO: return m
	var projection = m.dot(worm.position) / worm.position.dot(worm.position) * worm.position
	if m.dot(worm.position) > 0.0:
		return projection
	return Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	_t += delta
	var curl_noise := _curl_noise(Vector2(_t, _t))
	var m := curl_noise * speed # proposed movement vector
	var outward := _calculate_outward_component(m)
	var movement_scale = pow(worm.position.length() / max_range, 2.0)
	worm.position += m - (outward * movement_scale)
	
	
