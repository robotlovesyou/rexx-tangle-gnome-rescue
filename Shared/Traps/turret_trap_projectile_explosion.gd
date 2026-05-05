class_name TurretTrapProjectileExplosion
extends Node2D

var explosion_particles: GPUParticles2D:
	get: return $ExplosionParticles


func explode() -> void:
	explosion_particles.emitting = true
	explosion_particles.restart()


var _t := 0.0

func _physics_process(delta: float) -> void:
	_t += delta
	if _t >= explosion_particles.lifetime:
		queue_free()