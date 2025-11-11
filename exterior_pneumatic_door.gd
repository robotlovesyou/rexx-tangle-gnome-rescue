extends Node2D

@export var audio_player: AudioStreamPlayer2D


func play_door_sound() -> void:
	audio_player.play()
