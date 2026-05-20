extends Node2D

@export var totems: Array[FireTotem]


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		for totem in totems:
			totem.active = true
