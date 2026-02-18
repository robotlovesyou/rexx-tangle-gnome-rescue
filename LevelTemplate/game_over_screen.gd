@tool
class_name GameOverScreen
extends Node2D

enum Reason {
	NOT_ENOUGH_GNOMES,
	TIMED_OUT
}

@export var start_over_path: String

var _initialized = false
var _tile_h_count: int
@export var tile_h_count: int:
	get: return _tile_h_count
	set(val): 
		_tile_h_count = val
		if is_node_ready():
			_parallax_background.tile_h_count = _tile_h_count

var _gradient_texture: GradientTexture1D
@export var gradient_texture: GradientTexture1D:
	get: return _gradient_texture
	set(val): 
		_gradient_texture = val
		if is_node_ready():
			_parallax_background.gradient_texture = _gradient_texture

var _resample_chance: float
@export var resample_chance: float:
	get: return _resample_chance
	set(val): 
		_resample_chance = val
		if is_node_ready():
			_parallax_background.resample_chance = _resample_chance

var _cycle_frequency: float
@export var cycle_frequency: float:
	get: return _cycle_frequency
	set(val):
		_cycle_frequency = val
		if is_node_ready():
			_parallax_background.cycle_frequency = _cycle_frequency

var _reason := Reason.NOT_ENOUGH_GNOMES
var reason: Reason:
	get: return _reason
	set(val): 
		_reason = val
		if is_node_ready():
			_set_reason_text()

var _parallax_background: ParallaxBackground:
	get: return $ParallaxBackground

var _reason_label: RichTextLabel:
	get: return $CanvasLayer/MarginContainer/VBoxContainer/ReasonLabel

func _ready() -> void:
	_tile_h_count = _parallax_background.tile_h_count
	_gradient_texture = _parallax_background.gradient_texture
	_resample_chance = _parallax_background.resample_chance
	_cycle_frequency = _parallax_background.cycle_frequency
	_set_reason_text()
	_initialized = true

func _set_reason_text() -> void:
	match _reason:
		Reason.NOT_ENOUGH_GNOMES:
			_reason_label.text = "Not Enough Gnomes Left to Rescue"
		Reason.TIMED_OUT:
			_reason_label.text = "Ran Out of Time"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(start_over_path)
