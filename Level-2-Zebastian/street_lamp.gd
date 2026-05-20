extends Node2D


const DIM_PROPORTION := 0.5
const TRIG_PROBABILITY := 0.33

var light: PointLight2D:
	get: return $PointLight2D
	
var _base_energy: float
	
var dim_env := ADEnvelope.new(0.05, 0.25, false)

func _ready() -> void:
	_base_energy = light.energy
	Events.beat_channel_1.connect(_on_beat)

func _physics_process(delta: float) -> void:
	dim_env.progress(delta)
	light.energy = _base_energy - (dim_env.sample() * DIM_PROPORTION)
	
func _on_beat() -> void:
	if randf() <= TRIG_PROBABILITY:
		dim_env.trigger()
