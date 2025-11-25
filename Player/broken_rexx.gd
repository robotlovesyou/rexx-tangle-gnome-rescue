class_name BrokenRexx
extends Node2D

const LIFE_TIME_SECONDS = 2.0


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
	top_left.apply_central_impulse(top_left.mass * scaled_velocity)
	top_left.apply_torque_impulse(scaled_velocity.x)
	top_right.apply_central_impulse(top_right.mass * scaled_velocity)
	top_right.apply_torque_impulse(scaled_velocity.x)
	bottom_left.apply_central_impulse(bottom_left.mass * scaled_velocity)
	bottom_left.apply_torque_impulse(scaled_velocity.x)
	bottom_right.apply_central_impulse(bottom_right.mass * scaled_velocity)
	bottom_right.apply_torque_impulse(scaled_velocity.x)
	leg_1.apply_central_impulse(leg_1.mass * scaled_velocity)
	leg_1.apply_torque_impulse(scaled_velocity.x)
	leg_2.apply_central_impulse(leg_2.mass * scaled_velocity)
	leg_2.apply_torque_impulse(scaled_velocity.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE_TIME_SECONDS:
		self.queue_free()
