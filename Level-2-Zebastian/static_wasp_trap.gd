class_name StaticWaspTrap
extends Node2D

var sting_player: AudioStreamPlayer2D:
	get: return $StingPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player: return
	sting_player.play()
	Events.player_poisoned_async()
