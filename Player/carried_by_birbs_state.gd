class_name CarriedByBirbsState
extends PlayerState

var _collision_mask := 0
var _collision_layer := 0
var _last_position := Vector2.ZERO

const EMPY_MASK := 0

func _init(parent: Player):
	_parent = parent

func on_enter() -> void:
	Events.birbs_moved_player.connect(birbs_moved_player)
	_collision_mask = _parent.collision_mask
	_parent.collision_mask = EMPY_MASK
	_collision_layer = _parent.collision_layer
	_parent.collision_layer = EMPY_MASK
	_last_position = _parent.global_position
	
func on_exit() -> void:
	Events.birbs_moved_player.disconnect(birbs_moved_player)
	_parent.collision_mask = _collision_mask
	_parent.collision_layer = _collision_layer
	
	
func on_physics_process(delta: float) -> void:
	MovementHistory.append(_parent.position, _parent.get_platform_velocity() * delta, Enums.Action.JUMPING, _parent.animated_sprite.flip_h)
	
	
func birbs_moved_player(to: Vector2) -> void:
	_parent.global_position = to
	
func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.flip_h = _parent.global_position.x != _last_position.x and _parent.global_position.x > _last_position.x
	_last_position = _parent.global_position
	animated_sprite.play("jump")
