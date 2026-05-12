class_name CoinDeath
extends GPUParticles2D

var _t := 0.0

func play(count: int) -> void:
	amount = count
	restart()
	
func _physics_process(delta: float) -> void:
	_t += delta
	if _t > lifetime:
		queue_free()
