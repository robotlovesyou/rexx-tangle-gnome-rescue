extends Sprite2D

func _ready() -> void:
	var mat = material.duplicate()
	mat.set_shader_parameter("offset", randf())
	material = mat
