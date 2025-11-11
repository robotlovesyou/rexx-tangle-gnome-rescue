extends Control

@export var next_screen: String
@export var rexx_button: Button
@export var rexx_player: AnimationPlayer
@export var player_description: Label
@export_multiline var rexx_description: String
@export var rexxi_player: AnimationPlayer
@export_multiline var rexxi_description: String


func _ready() -> void:
	rexx_button.grab_focus()

func _on_rexx_button_focus_entered() -> void:
	rexx_player.play("walk")
	rexxi_player.play("idle")
	player_description.text = rexx_description


func _on_rexxi_button_focus_entered() -> void:
	rexxi_player.play("walk")
	rexx_player.play("idle")
	player_description.text = rexxi_description


func _on_rexx_button_pressed() -> void:
	get_tree().change_scene_to_file(next_screen)
