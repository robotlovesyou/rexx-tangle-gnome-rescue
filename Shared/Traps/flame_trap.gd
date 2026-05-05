class_name FlameTrap
extends Node2D

@export var lit := true

var point_light: PointLight2D:
	get: return $Fire/PointLight2D
	
func _ready() -> void:
	point_light.enabled = lit

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_burned_async()
	if body is Gnome:
		Events.gnome_burned_async(body as Gnome)
