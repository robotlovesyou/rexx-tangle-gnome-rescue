class_name SpiderWeb
extends Node2D

const MIN_PITCH := 0.5
const MAX_PITCH := 2.0

var _caught_at: Vector2
var _player_caught := false
var _strands: Array[Line2D] = []
var broken_strand_scene := preload("res://Level-2-Zebastian/broken_strand.tscn")

var boing: AudioStreamPlayer2D:
	get: return $Boing
	
var stretch: AudioStreamPlayer2D:
	get: return $Stretch

func _on_catch_area_body_entered(body: Node2D) -> void:
	if body is not Player or _player_caught: return
	Events.player_caught_in_web_sync(self)
	Events.player_broke_web.connect(_broke_web)
	stretch.play()
	_player_caught = true
	_caught_at = to_local((body as Player).global_position)
	_init_strands()
	
func _broke_web() -> void:
	_player_caught = false
	for strand in _strands:
		var center = (strand.points[0] + strand.points[1]) / 2.0
		var particles = broken_strand_scene.instantiate() as GPUParticles2D
		add_child(particles)
		particles.position = center
		particles.restart()
		strand.queue_free()
	_strands = []
	stretch.stop()
	boing.play()
	
func _init_strands() -> void:
	var targets = PMonitor.player.anchor_points
	for target in targets:
			_add_strand(Vector2.ZERO, to_local(target))
	for gnome in FollowersMonitor.all:
		_add_strand(Vector2.ZERO, to_local(gnome.global_position))
		
		
func _add_strand(from: Vector2, to: Vector2) -> void:
	var strand = Line2D.new()
	strand.add_point(from)
	strand.add_point(to)
	strand.default_color = Color.WHITE
	strand.width = 2.0
	add_child(strand)
	_strands.append(strand)
			
func _physics_process(_delta: float) -> void:
	var anchor_points := PMonitor.player.anchor_points
	if _player_caught:
		var distance_from_catch = _caught_at.distance_to(to_local(PMonitor.player.global_position))
		var new_pitch = remap(distance_from_catch / WebbedStrategy.BREAK_DISTANCE, 0.0, 1.0, MIN_PITCH, MAX_PITCH)
		stretch.pitch_scale = new_pitch
		for i in range(anchor_points.size()):
			_strands[i].remove_point(1)
			_strands[i].add_point(to_local(anchor_points[i]))
			
		var gnomes := FollowersMonitor.all
		for i in range(gnomes.size()):
			_strands[i + anchor_points.size()].remove_point(1)
			_strands[i + anchor_points.size()].add_point(to_local(gnomes[i].global_position))
