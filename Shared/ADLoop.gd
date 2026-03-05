class_name ADLoop
extends Resource

signal phase_changed(Phase)

@export var attack := 1.0
@export var decay := 1.0
@export var time_offset := 0.0
var _t := 0.0
var _sample := 0.0

enum Phase {ATTACK, DECAY}
var _phase = Phase.ATTACK

func ready() -> void:
	_t = time_offset

func physics_update(delta: float) -> void:
	_t += delta
	_sample = _calc_env_value()
	

func _calc_env_value() -> float:
	match _phase:
		Phase.ATTACK:
			if _t >= attack:
				_phase = Phase.DECAY
				phase_changed.emit(_phase)
				return _calc_env_value()
			return _t / attack
		_:
			if _t >= attack + decay:
				_t -= (attack+decay)
				_phase = Phase.ATTACK
				phase_changed.emit(_phase)
				return _calc_env_value()
			return 1.0 - ((_t - attack) / decay)

func sample() -> float: return _sample
	
