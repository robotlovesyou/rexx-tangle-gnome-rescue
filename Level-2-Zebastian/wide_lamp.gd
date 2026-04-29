extends Node2D

@export var strength := 1.0

func _ready() -> void:
	$LampLight.energy = strength
