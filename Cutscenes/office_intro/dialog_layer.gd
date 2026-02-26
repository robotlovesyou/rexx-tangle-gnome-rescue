class_name CutsceneDialogLayer
extends CanvasLayer

signal pause_requested

var _dialog_animations: AnimationPlayer:
	get: return $DialogAnimations
	
var _dialog_label: RichTextLabel:
	get: return $CenterContainer/NinePatchRect/MarginContainer/HBoxContainer/VBoxContainer/TrainingDialogLabel
	
var _dialog_portrait: TextureRect:
	get: return $CenterContainer/NinePatchRect/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/Portrait
	
var _dialog_portrait_name: Label:
	get: return $CenterContainer/NinePatchRect/MarginContainer/HBoxContainer/PanelContainer/VBoxContainer/PortraitLabel

func open(text: String, portrait_path: String, portrait_name) -> void:
	_dialog_portrait.texture = load(portrait_path)
	_dialog_label.text = text
	_dialog_portrait_name.text = portrait_name
	_dialog_animations.play("open_dialog")
	pause_requested.emit.call_deferred()
	
func close() -> void:
	_dialog_animations.play("close_dialog")
