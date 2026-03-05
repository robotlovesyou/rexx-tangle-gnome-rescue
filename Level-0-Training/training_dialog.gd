class_name TrainingDialog
extends Node2D

signal training_dialog_requested(String)
signal training_dialog_freed(String)

@export_multiline var text: String = ""

var _active := true
var active: bool:
	get: return _active
	set(value): 
		_active = value
		#if _active == false:
			#training_dialog_freed.emit(text)

func _on_activation_area_body_entered(body: Node2D) -> void:
	if not _active or not body is Player: return
	training_dialog_requested.emit(text)


func _on_activation_area_body_exited(body: Node2D) -> void:
	if not body is Player: return
	training_dialog_freed.emit(text)
