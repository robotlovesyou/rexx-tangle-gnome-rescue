class_name WebbedStrategy
extends AliveStrategy

const BREAK_DISTANCE := 200.0
const MAX_SLOWDOWN_FACTOR := 2.0

var _caught_at: Vector2
var _web: SpiderWeb

func _init(parent: Player, web: SpiderWeb):
	super(parent)
	_web = web
	
	
func on_enter() -> void:
	_caught_at = _parent.global_position

func _modify_velocity(velocity: Vector2) -> Vector2:
	if _parent.global_position.distance_to(_caught_at) > BREAK_DISTANCE:
		Events.player_broke_web_sync()
		return velocity
		
	return velocity / min(1.0 + _parent.global_position.distance_to(_caught_at) / BREAK_DISTANCE, MAX_SLOWDOWN_FACTOR)
