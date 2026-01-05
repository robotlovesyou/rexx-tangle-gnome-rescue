class_name SpikeTrap

extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_hit_spike_trap_async(self)
	elif body is Gnome:
		Events.gnome_hit_spike_trap_async(self, body as Gnome)
