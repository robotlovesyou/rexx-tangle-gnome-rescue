class_name Coin
extends Node2D

@export var coin_collected_effect: PackedScene

var _collected := false

func _on_collection_area_body_entered(body: Node2D) -> void:
	if body is not Player or _collected: return
	_collected = true
	Events.player_collected_coin_async(self)
	
func collected() -> void:
	var collected_effect := coin_collected_effect.instantiate() as CoinCollectedEffect
	get_parent().add_child(collected_effect)
	collected_effect.global_position = global_position
	queue_free()
