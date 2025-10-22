extends Control

@export var first_button: Button
@export var next_screen: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_button.grab_focus()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_screen)
