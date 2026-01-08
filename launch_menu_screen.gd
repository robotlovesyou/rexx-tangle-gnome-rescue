extends Control

signal new_game_clicked
signal quit_to_desktop_clicked

@export var first_button: Button
@export var next_screen: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_button.grab_focus()


func _on_quit_button_pressed() -> void:
	quit_to_desktop_clicked.emit()


func _on_new_game_button_pressed() -> void:
	new_game_clicked.emit()
