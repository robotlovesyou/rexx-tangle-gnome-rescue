class_name BirbRope
extends Node2D

var rope: Sprite2D: 
	get: return $Rope
	
func update_span(from: Vector2, to: Vector2) -> void:
	var midpoint = (from + to) / 2.0
	global_position = midpoint
	rope.global_rotation = midpoint.angle_to_point(to)
	rope.region_rect.size.x = from.distance_to(to)
	
	
	
