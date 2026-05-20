extends Node2D

const TWEEN_TIME_SECONDS := 0.25
const ONE_OVER_PHI := 1.0 / ((1.0 + sqrt(5.0)) / 2.0)
@export var strength := 1.0
@export var color_gradient: GradientTexture2D

var _current_tween: Tween
var current_light_sample_point := 0.0

func _ready() -> void:
	$LampLight.energy = strength
	Events.beat_channel_2.connect(_on_beat)
	
func _physics_process(_delta: float) -> void:
	$LampLight.color = color_gradient.gradient.sample(current_light_sample_point)
	
func _on_beat() -> void:
	if _current_tween and _current_tween.is_running():
		_current_tween.kill()
	
	var target_val = fmod(ONE_OVER_PHI + randf(), 1.0)
	_current_tween = create_tween()
	_current_tween.tween_property(self, "current_light_sample_point", target_val, TWEEN_TIME_SECONDS)
	_current_tween.set_ease(Tween.EASE_IN_OUT)
	
	
