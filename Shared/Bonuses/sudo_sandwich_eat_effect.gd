class_name SudoSandwichEatEffect
extends Node2D

const LIFETIME_SECONDS := 2.0

var _t := 0.0

func _ready() -> void:
	$GPUParticles2D.restart()
	
func _physics_process(delta: float) -> void:
	_t += delta
	if _t > LIFETIME_SECONDS:
		queue_free()
