class_name CarriedByBirbsStrategy
extends PlayerStrategy

var _last_position := Vector2.ZERO

func _init(parent: Player):
	_parent = parent

func on_enter() -> void:
	Events.birbs_moved_player.connect(birbs_moved_player)
	_parent.set_collision_layer_value(LayerConstants.PLAYER, false)
	_parent.set_collision_mask_value(LayerConstants.TERRAIN, false)
	_parent.set_collision_mask_value(LayerConstants.ENEMY, false)
	_parent.set_collision_mask_value(LayerConstants.DROP_TRAP, false)
	_parent.set_collision_mask_value(LayerConstants.GNOMEPAQUE_TERRAIN, false)
	_last_position = _parent.global_position
	
func on_exit() -> void:
	Events.birbs_moved_player.disconnect(birbs_moved_player)
	_parent.set_collision_layer_value(LayerConstants.PLAYER, true)
	_parent.set_collision_mask_value(LayerConstants.TERRAIN, true)
	_parent.set_collision_mask_value(LayerConstants.ENEMY, true)
	_parent.set_collision_mask_value(LayerConstants.DROP_TRAP, true)
	_parent.set_collision_mask_value(LayerConstants.GNOMEPAQUE_TERRAIN, true)
	
	
func on_physics_process(delta: float) -> void:
	MovementHistory.append(_parent.position, _parent.get_platform_velocity() * delta, Enums.Action.JUMPING, _parent.animated_sprite.flip_h)
	
	
func birbs_moved_player(to: Vector2) -> void:
	_parent.global_position = to
	
func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.flip_h = _parent.global_position.x != _last_position.x and _parent.global_position.x > _last_position.x
	_last_position = _parent.global_position
	animated_sprite.play("jump")
