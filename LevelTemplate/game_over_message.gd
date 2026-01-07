class_name GameOverMessage
extends CanvasLayer

@export var reason_label: Label

func set_reason(reason: String) -> void:
    reason_label.text = reason
