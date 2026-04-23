class_name BurningStrategy
extends PlayerStrategy

const BURN_TIME := 0.8
const TIME_UNTIL_DONE := 2.0 * BURN_TIME
const BURN_WIDTH := 0.05
var _t := 0.0
var _done := false
var _animation_playing := false

func on_enter() -> void:
	_parent.start_burn()
	ActionMonitor.action = Enums.Action.DYING
	
func on_physics_process(delta: float) -> void:
	super(delta)
	_t += delta
	var amount = _t / BURN_TIME
	
	if _t > BURN_TIME:
		_done = true
		_parent.stop_burn()
		_parent.set_flame_amount(1.0)
		_parent.set_burn_amount(1.0)
		_parent.set_hide_amount(1.0)	
		
	if not _done:
		_parent.set_flame_amount(amount)
		_parent.set_burn_amount(amount - BURN_WIDTH)
		_parent.set_hide_amount(amount - 2.0 * BURN_WIDTH)	
		
	if _t > TIME_UNTIL_DONE:
		_parent.done_disappearing()
	
func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	if not _animation_playing:
		_animation_playing = true
		animated_sprite.play("disappear")
