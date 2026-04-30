class_name BackgroundTree
extends Node2D

@export var tree_textures: Array[CompressedTexture2D]
@export var trunks: Array[Sprite2D]
@export var darken_factor := 0.8

func _ready() -> void:
	_prepare_trunks()
	
func _prepare_trunks() -> void:
	for trunk in trunks:
		prepare_trunk(trunk)
	
func prepare_trunk(trunk: Sprite2D):
	trunk.texture = tree_textures.pick_random()
	trunk.material = trunk.material.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	trunk.material.set_shader_parameter("darken_factor", darken_factor)
