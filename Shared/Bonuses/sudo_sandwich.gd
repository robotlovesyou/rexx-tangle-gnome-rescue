class_name SudoSandwich
extends Node2D

@export var eat_effect_scene: PackedScene

var _collected := false

func _on_collection_area_body_entered(body: Node2D) -> void:
	if not body is Player or _collected: return
	Events.player_collected_sandwich_async(self)
	_collected = true
	
func eat() -> void:
	var eat_effect := eat_effect_scene.instantiate() as SudoSandwichEatEffect
	get_parent().add_child(eat_effect)
	eat_effect.global_position = self.global_position
	queue_free()
