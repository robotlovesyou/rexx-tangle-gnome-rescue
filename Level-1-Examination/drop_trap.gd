class_name DropTrap
extends Node2D

@export var cycle_envelope: ADLoop

var _path_follow: PathFollow2D:
	get: return $Path2D/PathFollow2D

var _trap_body: AnimatableBody2D:
	get: return $TrapBody

func _ready() -> void:
	assert(cycle_envelope != null, 'A value must be assigned to the cycle envelope')
	cycle_envelope.ready()

func _physics_process(delta: float) -> void:
	cycle_envelope.physics_update(delta)
	_path_follow.progress_ratio = cycle_envelope.sample()
	_trap_body.position.y = _path_follow.position.y