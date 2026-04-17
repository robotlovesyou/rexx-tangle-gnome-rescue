class_name SpiderWeb
extends Node2D


var _player_caught := false
var _strands: Array[Line2D] = []

func _on_catch_area_body_entered(body: Node2D) -> void:
	if body is not Player: return
	Events.player_caught_in_web_sync(self)
	Events.player_broke_web.connect(_broke_web)
	_player_caught = true
	_init_strands()
	
func _broke_web() -> void:
	_player_caught = false
	for strand in _strands:
		strand.queue_free()
	_strands = []
	
func _init_strands() -> void:
	var targets = PMonitor.player.anchor_points
	for target in targets:
			var strand = Line2D.new()
			strand.add_point(Vector2.ZERO)
			strand.add_point(to_local(target))
			strand.default_color = Color.WHITE
			strand.width = 2.0
			add_child(strand)
			_strands.append(strand)
			
func _physics_process(_delta: float) -> void:
	if _player_caught:
		for i in range(_strands.size()):
			_strands[i].remove_point(1)
			_strands[i].add_point(to_local(PMonitor.player.anchor_points[i]))
