class_name WebbedStrategy
extends AliveStrategy

const MAX_SLOWDOWN_FACTOR := 2.0

var _caught_at: Vector2
var _web: SpiderWeb

func _init(parent: Player, web: SpiderWeb):
	super(parent)
	_web = web
	
func _check_falling() -> void:
	pass
	
func on_enter() -> void:
	_caught_at = _parent.global_position
	_input_strategy = StandardInputStrategy.new()
	
func on_exit() -> void:
	_web.release_player()

func _modify_velocity(velocity: Vector2) -> Vector2:
	if _parent.global_position.distance_to(_caught_at) > _web.break_distance:
		Events.player_broke_web_sync()
		_parent.broke_web()
		return velocity
		
	return velocity / min(1.0 + _parent.global_position.distance_to(_caught_at) / _web.break_distance, MAX_SLOWDOWN_FACTOR)
