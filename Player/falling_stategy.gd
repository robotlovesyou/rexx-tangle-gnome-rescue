class_name FallingStrategy
extends PlayerStrategy

func on_enter() -> void:
	_parent.show_speed_lines()
	_parent.play_scream()
	
func on_exit() -> void:
	_parent.hide_speed_lines()
	_parent.stop_scream()
	
func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.play("falling")
	
func on_physics_process(delta: float) -> void:
	_parent.velocity += _parent.get_gravity() * delta
	_parent.move_and_slide()
	if _parent.is_on_floor():
		Events.player_hit_floor_fatally_async()
