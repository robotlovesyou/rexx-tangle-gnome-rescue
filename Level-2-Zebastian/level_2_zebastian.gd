class_name Level2Zebastian
extends BaseLevel

func _ready() -> void:
	super()
	Events.player_hit_ghost.connect(_on_player_hit_ghost)
	
	
func _on_player_hit_ghost(ghost: PathFollowerGhost) -> void:
	_scare_player(ghost.global_position)
	
func _scare_player(source: Vector2) -> void:
	PMonitor.player.scare(source)
