class_name SpawnPoint
extends Node2D

@export var active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if active:
		Level.spawn_point = self
