class_name ViewportScaleManager
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	get_viewport().size_changed.connect(_on_resize)


func _on_resize() -> void:
	print("hello resize")
	print(get_viewport().get_visible_rect())
