class_name GlowWormSpawner
extends Node2D

@export var glow_worm_scene: PackedScene
@export var glow_worm_count := 3
@export var max_range := 100
@export var min_range := 3.0
@export var max_center_offset := 20.0
@export var spawner_speed := 2.0
@export var worm_speed := 50.0

var spawner_center: Node2D:
	get: return $SpawnerCenter
	
var _range_noise: FastNoiseLite
var _worms: Array[GlowWorm]
var _t := 0.0
var _movement_worm

func _ready() -> void:
	_range_noise = FastNoiseLite.new()
	_range_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_range_noise.seed = randi_range(-1000,1000)
	for i in range(glow_worm_count):
		var instance = glow_worm_scene.instantiate() as GlowWorm
		spawner_center.add_child(instance)
		instance.position = Vector2.ZERO
		instance.max_range = max_range
		instance.speed = worm_speed
		_worms.append(instance)
		
	# TODO: using a worm to move the center is hacky. Abstract out the movement code for worms and use it in both placqes
	_movement_worm = glow_worm_scene.instantiate() as GlowWorm
	_movement_worm.hide()
	_movement_worm.speed = worm_speed
	_movement_worm.max_range = max_center_offset
	_movement_worm.position = Vector2.ZERO
	add_child(_movement_worm)
		
		
func _physics_process(delta: float) -> void:
	_t += delta
	spawner_center.position = _movement_worm.worm.position
	var range_scale := 4.0 * _range_noise.get_noise_2d(spawner_speed * _t, spawner_speed * _t)
	var modulated_range = max(min_range, min(abs(max_range * range_scale), max_range))
	for worm in _worms:
		worm.max_range = modulated_range
