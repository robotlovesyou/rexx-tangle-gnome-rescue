extends Control

@export var rexx_button: Button
@export var rexx_player: AnimationPlayer
@export var player_description: Label
@export_multiline var rexx_description: String
@export var rexxi_player: AnimationPlayer
@export_multiline var rexxi_description: String



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rexx_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rexx_button_focus_entered() -> void:
	rexx_player.play("walk")
	rexxi_player.play("idle")
	player_description.text = rexx_description


func _on_rexxi_button_focus_entered() -> void:
	rexxi_player.play("walk")
	rexx_player.play("idle")
	player_description.text = rexxi_description
