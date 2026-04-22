class_name BurningStrategy
extends PlayerStrategy

const BURN_TIME := 0.8
const BURN_WIDTH := 0.05
var _amount := 0.0

func on_enter() -> void:
	_parent.start_burn()
	
func on_physics_process(delta: float) -> void:
	_amount += delta / BURN_TIME
	
	if _amount > 1.0:
		_parent.stop_burn()
	_parent.set_flame_amount(_amount)
	_parent.set_burn_amount(_amount - BURN_WIDTH)
	_parent.set_hide_amount(_amount - 2.0 * BURN_WIDTH)
	
func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.play("disappear")
