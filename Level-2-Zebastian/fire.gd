extends Sprite2D

func _ready() -> void:
	var mat = preload("res://Level-2-Zebastian/fire_shader_material.tres").duplicate()
	mat.set_shader_parameter("offset", randf())
	material = mat
	
