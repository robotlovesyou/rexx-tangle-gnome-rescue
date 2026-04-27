class_name Level2Zebastian
extends BaseLevel

func _ready() -> void:
	super()
	Events.player_hit_ghost.connect(_on_player_hit_ghost)
	
	
func _on_player_hit_ghost() -> void:
	_scare_player()
	
func _scare_player() -> void:
	PMonitor.player.scare()
