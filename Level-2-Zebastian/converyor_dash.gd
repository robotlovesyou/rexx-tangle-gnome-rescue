class_name ConveyorDash
extends Node2D

@export var plank_scene: PackedScene
@export var travel_time_seconds := 20.0
var _followers_queue: Array[PathFollow2D] = []
var _planks_queue: Array[Plank] = []

var converyor_path: Path2D:
	get: return $ConveyorPath
	
func _ready() -> void:
	_create_follower()
	_create_plank()
	
func _create_follower() -> void:
	var follower = PathFollow2D.new()
	converyor_path.add_child(follower)
	follower.progress_ratio = 0.0
	follower.loop = false
	_followers_queue.push_back(follower)
	
	
func _create_plank() -> void:
	var plank := plank_scene.instantiate() as Plank
	add_child(plank)
	_planks_queue.push_back(plank)
	
func _physics_process(delta: float) -> void:
	if _followers_queue.back().progress >= _planks_queue.back().width:
		_create_plank()
		_create_follower()
		
	for i in _followers_queue.size():
		var follower = _followers_queue[i]
		var plank = _planks_queue[i]
		follower.progress_ratio += delta/travel_time_seconds
		plank.global_position.x = follower.global_position.x
		
	if _followers_queue.front().progress_ratio >= 1.0:
		(_followers_queue.pop_front()).queue_free()
		(_planks_queue.pop_front()).queue_free()
	
