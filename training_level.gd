extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MovementHistory.reset($Player.position, Enums.Action.IDLING)
	PMonitor.player = $Player
