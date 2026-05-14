class_name SpiderWeb
extends Node2D

const MIN_PITCH := 0.5
const MAX_PITCH := 2.0

@export var break_distance := 100.0
var _caught_at: Vector2
var _player_caught := false
var _strands: Array[Line2D] = []
var broken_strand_scene := preload("res://Shared/Traps/broken_strand.tscn")

var boing: AudioStreamPlayer2D:
	get: return $Boing
	
var stretch: AudioStreamPlayer2D:
	get: return $Stretch
	
var anchor_points: Array[Node2D]:
	get:
		var anchors: Array[Node2D] 
		for anchor in $AnchorPoints.get_children():
			if anchor is Node2D:
				anchors.append(anchor as Node2D)
			
		return anchors
	
func _find_closest_anchor_point(to: Vector2) -> Node2D:
	var points := anchor_points
	var closest := points[0]
	var distance_to := closest.position.distance_to(to)
	
	for point in points:
		var dt = point.position.distance_to(to)
		if dt < distance_to:
			distance_to = dt
			closest = point
	return closest

func _on_catch_area_body_entered(body: Node2D) -> void:
	if body is not Player or _player_caught: return
	Events.player_caught_in_web_sync(self)
	Events.player_broke_web.connect(_broke_web)
	stretch.play()
	_player_caught = true
	_caught_at = to_local((body as Player).global_position)
	_init_strands(_caught_at)
	
func _broke_web() -> void:
	for strand in _strands:
		var center = (strand.points[0] + strand.points[1]) / 2.0
		var particles = broken_strand_scene.instantiate() as GPUParticles2D
		add_child(particles)
		particles.position = center
		particles.restart()
	
	release_player()
	boing.play()
	
func release_player() -> void:
	for strand in _strands:
		strand.queue_free()
		_player_caught = false
		stretch.stop()
		_strands = []
	Events.player_broke_web.disconnect(_broke_web)
	
func _init_strands(to: Vector2) -> void:
	var closest = _find_closest_anchor_point(to)
	var targets = PMonitor.player.anchor_points
	for target in targets:
			_add_strand(closest.position, to_local(target))
	for gnome in FollowersMonitor.all:
		_add_strand(closest.position, to_local(gnome.global_position))
		
		
func _add_strand(from: Vector2, to: Vector2) -> void:
	var strand = Line2D.new()
	strand.position = Vector2.ZERO
	strand.add_point(from)
	strand.add_point(to)
	strand.default_color = Color.WHITE
	strand.width = 2.0
	add_child(strand)
	_strands.append(strand)
			
func _physics_process(_delta: float) -> void:
	var player_anchor_points := PMonitor.player.anchor_points
	if _player_caught:
		var distance_from_catch = _caught_at.distance_to(to_local(PMonitor.player.global_position))
		var new_pitch = remap(distance_from_catch / break_distance, 0.0, 1.0, MIN_PITCH, MAX_PITCH)
		stretch.pitch_scale = new_pitch
		for i in range(player_anchor_points.size()):
			_strands[i].remove_point(1)
			_strands[i].add_point(to_local(player_anchor_points[i]))
			
		var gnomes := FollowersMonitor.all
		for i in range(gnomes.size()):
			_strands[i + player_anchor_points.size()].remove_point(1)
			_strands[i + player_anchor_points.size()].add_point(to_local(gnomes[i].global_position))
