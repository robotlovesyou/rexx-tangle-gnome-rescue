class_name ADEnvelope
extends RefCounted

var _attack := 0.0
var _decay := 0.0
var _t := 0.0
var _t_at_trigger := 0.0
var _t_since_trigger := 0.0
var _sample := 0.0

enum Phase {IDLE, ATTACK, DECAY}
var _phase = Phase.IDLE

func _init(a: float, d: float):
	assert(a > 0.0, "a cannot be zero")
	assert(d > 0.0, "d cannot be zero" )
	_attack = a
	_decay = d

func progress(delta: float) -> void:
	_t += delta
	_t_since_trigger = _t - _t_at_trigger
	_sample = _calc_env_value()
	

func _calc_env_value() -> float:
	match _phase:
		Phase.ATTACK:
			if _t_since_trigger >= _attack:
				_phase = Phase.DECAY
				return _calc_env_value()
			return _t_since_trigger / _attack
		Phase.DECAY:
			if _t_since_trigger >= _attack + _decay:
				_phase = Phase.IDLE
				return _calc_env_value()
			return 1.0 - ((_t_since_trigger - _attack) / _decay)
		Phase.IDLE, _:
			return 0.0

func trigger() -> void:
	if _phase == Phase.IDLE:
		_t_at_trigger = _t
		_phase = Phase.ATTACK

func sample() -> float: return _sample
	

