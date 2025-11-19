class_name TrainingDialogsLayer
extends CanvasLayer

@export var animation_player: AnimationPlayer
@export var label: RichTextLabel

var _current_text := ""

func open(text: String) -> void:
	label.text = text
	animation_player.play("open_dialog")

func close(text: String) -> void:
	if text != _current_text: return
	animation_player.play("close_dialog")


func _on_animation_finished(_anim_name: StringName) -> void:
	pass
