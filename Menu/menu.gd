extends Node2D



var menu_music: AudioStreamPlayer: 
	get: return $MenuMusic

func _on_quit_to_desktop_clicked() -> void:
	print("quit")

func _on_new_game_clicked() -> void:
	print("new game")


func _on_menu_music_finished() -> void:
	menu_music.play()
