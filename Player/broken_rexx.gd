class_name BrokenRexx
extends Node2D

const LIFE_TIME_SECONDS := 2.0


var top_left: RigidBody2D:
	get: return $TopLeftBody

var top_right: RigidBody2D:
	get: return $TopRightBody

var bottom_left: RigidBody2D:
	get: return $BottomLeftBody

var bottom_right: RigidBody2D:
	get: return $BottomRightBody

var leg_1: RigidBody2D:
	get: return $Leg1Body

var leg_2: RigidBody2D:
	get: return $Leg2Body

var _t := 0.0

func set_initial_velocity(velocity: Vector2) -> void:
	var scaled_velocity = velocity / (Engine.physics_ticks_per_second / 2.0)
	_apply_body_impulse(top_left, scaled_velocity)
	_apply_body_impulse(top_right, scaled_velocity)
	_apply_body_impulse(bottom_left, scaled_velocity)
	_apply_body_impulse(bottom_right, scaled_velocity)
	_apply_body_impulse(leg_1, scaled_velocity)
	_apply_body_impulse(leg_2, scaled_velocity)

func _apply_body_impulse(body: RigidBody2D, scaled_velocity: Vector2):
	body.apply_central_impulse(body.mass * scaled_velocity)
	body.apply_torque_impulse(scaled_velocity.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE_TIME_SECONDS:
		self.queue_free()
