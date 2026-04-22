class_name BurningStrategy
extends PlayerStrategy

const BURN_TIME := 1.5
const BURN_WIDTH := 0.1
var _amount := 0.0

func on_enter() -> void:
	_parent.start_burn()
	
func on_physics_process(delta: float) -> void:
	_amount += delta / BURN_TIME
	
	if _amount > 1.0:
		_parent.stop_burn()
	_parent.set_burn_amount(_amount)
	_parent.set_hide_amount(_amount - BURN_WIDTH)
