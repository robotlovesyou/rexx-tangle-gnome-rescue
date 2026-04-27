class_name ScaredStrategy
extends AliveStrategy

const FEAR_TIME_SECONDS := 2.0
const SCREAM_FADE_SECONDS := 0.1

var _t := 0.0

func _init(parent: Player, direction: float):
	_direction = direction
	super(parent)

func on_enter() -> void:
	_input_strategy = FearInputStrategy.new(_direction)
	
func on_exit() -> void:
	_parent.fade_scream(SCREAM_FADE_SECONDS)
	
func on_physics_process(delta: float) -> void:
	super(delta)
	_t += delta
	if _parent.is_cast_on_wall():
		_direction *= -1.0
		_input_strategy = FearInputStrategy.new(_direction)
		
	if _t >= FEAR_TIME_SECONDS:
		_parent.done_being_scared()
		
func on_animate(animated_sprite: AnimatedSprite2D) -> void:
	animated_sprite.flip_h = _determine_flip()
	animated_sprite.play("fear")
