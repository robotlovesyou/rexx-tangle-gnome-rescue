extends Node2D

signal training_dialog_requested(String)
signal training_dialog_freed(String)

@export_multiline var text: String = ""

func _on_activation_area_body_entered(body: Node2D) -> void:
	if not body is Player: return
	training_dialog_requested.emit(text)


func _on_activation_area_body_exited(body: Node2D) -> void:
	if not body is Player: return
	training_dialog_freed.emit(text)
