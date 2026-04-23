extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_burned_async()
	if body is Gnome:
		Events.gnome_burned_async(body as Gnome)
