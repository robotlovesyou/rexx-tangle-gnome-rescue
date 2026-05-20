class_name StaticWaspTrap
extends Node2D

var sting_player: AudioStreamPlayer2D:
	get: return $StingPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		sting_player.play()
		Events.player_poisoned_async()
	elif body is Gnome:
		sting_player.play()
		Events.gnome_poisoned_async(body as Gnome)
