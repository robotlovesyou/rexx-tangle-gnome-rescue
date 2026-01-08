extends Node2D

@export var color_rect: ColorRect
@export var color_ramp: GradientTexture1D

var _t := 0.0

func _ready() -> void:
	color_ramp.gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_t += delta
	color_rect.color = color_ramp.gradient.sample(0.5 + 0.5 *(sin(2.0*PI*_t)))
