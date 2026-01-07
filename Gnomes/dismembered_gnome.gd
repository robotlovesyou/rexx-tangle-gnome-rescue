class_name DismemberedGnome
extends Node2D

const LIFE_TIME_SECONDS := 3.0

var head: RigidBody2D:
	get: return $DismemberedHead

var torso: RigidBody2D:
	get: return $DismemberedTorso

var leg_1: RigidBody2D:
	get: return $DismemberedLeg1

var leg_2: RigidBody2D:
	get: return $DismemberedLeg2

var arm_1: RigidBody2D:
	get: return $DismemberedArm1

var arm_2: RigidBody2D:
	get: return $DismemberedArm2

var _t := 0.0

func set_initial_velocity() -> void:
	_apply_body_impulse(head, Vector2.UP * 4000.0, 40.0)
	_apply_body_impulse(torso, Vector2.DOWN * 4000.0, 0.0)
	_apply_body_impulse(leg_1, Vector2.LEFT * 4000.0, -40.0)
	_apply_body_impulse(leg_2, Vector2.RIGHT * 4000.0, 40.0)
	_apply_body_impulse(arm_1, Vector2.LEFT * 4000, -40.0)
	_apply_body_impulse(arm_2, Vector2.RIGHT * 4000.0, 40.0)

func _apply_body_impulse(body: RigidBody2D, velocity: Vector2, torque: float):
	var scaled_velocity = velocity / Engine.physics_ticks_per_second
	body.apply_central_impulse(body.mass * scaled_velocity)
	body.apply_torque_impulse(torque * body.mass)


func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE_TIME_SECONDS:
		self.queue_free()
