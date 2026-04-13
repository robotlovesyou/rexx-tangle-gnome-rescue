class_name BirbSwarm
extends Node2D

enum Phase {Sleep, Arrive, WaitToTravel, Travel, WaitToLeave, Leave}

@export var arrive_time_seconds := 1.0
@export var wait_to_travel_time_seconds := 1.0
@export var travel_time_seconds := 1.0
@export var wait_to_leave_time_seconds := 1.0
@export var leave_time_seconds := 1.0
var _phase := Phase.Sleep
var _t := 0.0

var birb_particles: GPUParticles2D:
	get: return $BirbParticles
	
var arrive_follow: PathFollow2D:
	get: return $ArrivePath/ArriveFollow
	
var travel_follow: PathFollow2D:
	get: return $TravelPath/TravelFollow
	
var leave_follow: PathFollow2D:
	get: return $LeavePath/LeaveFollow

func start() -> void:
	if _phase == Phase.Sleep:
		_phase = Phase.Arrive
		birb_particles.restart()
		_t = 0.0
		
func _ready() -> void:
	start()
	
func _physics_process(delta: float) -> void:
	match _phase:
		Phase.Sleep:
			pass
		Phase.Arrive:
			_t += delta
			var ratio := _t / arrive_time_seconds
			arrive_follow.progress_ratio = min(ratio, 1.0)
			birb_particles.modulate.a = min(ratio, 1.0)
			birb_particles.global_position = arrive_follow.global_position
			if _t >= arrive_time_seconds:
				_phase = Phase.WaitToTravel
				_t = 0.0
		Phase.WaitToTravel:
			_t += delta
			if _t >= wait_to_travel_time_seconds:
				_phase = Phase.Travel
				_t = 0.0
		Phase.Travel:
			_t += delta
			var ratio := _t / travel_time_seconds
			travel_follow.progress_ratio = min(ratio, 1.0)
			birb_particles.global_position = travel_follow.global_position
			if _t >= travel_time_seconds: 
				_phase = Phase.Leave
				_t = 0.0
		Phase.WaitToLeave:
			_t += delta
			if _t >= wait_to_leave_time_seconds:
				_phase = Phase.Leave
				_t = 0.0
		Phase.Leave:
			_t += delta
			var ratio := _t / leave_time_seconds
			leave_follow.progress_ratio = min(ratio, 1.0)
			birb_particles.modulate.a = 1.0 - ratio
			birb_particles.global_position = leave_follow.global_position
			if _t >= leave_time_seconds:
				_phase = Phase.Sleep
				_t = 0.0
		
		
