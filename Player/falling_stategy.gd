class_name FallingStrategy
extends PlayerStrategy

var _fatal := false

func on_enter() -> void:
	_parent.show_speed_lines()
	
func on_exit() -> void:
	_parent.hide_speed_lines()
	_parent.stop_scream()
	
func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.play("falling")
	
func on_physics_process(delta: float) -> void:
	_parent.velocity += _parent.get_gravity() * delta
	_parent.move_and_slide()
	_parent.append_to_history(delta, Enums.Action.FALLING)
	if _parent.velocity.y > _parent.movement_config.FATAL_FALL_SPEED and not _fatal:
		_fatal = true
		_parent.play_scream()
		
	if _parent.is_on_floor():
		if _fatal:
			Events.player_hit_floor_fatally_async()
		else:
			_parent.stop_falling()
