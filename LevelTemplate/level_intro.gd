class_name Levelntro
extends Node2D

@export var characters_per_second := 5.0
@export var fade_time_seconds := 1.0
@export_multiline var intro_text: String
@export var intro_morse: AudioStreamWAV
@export var tile_h_count := 16
@export var gradient_texture: GradientTexture1D
@export var resample_chance := 0.01
@export var cycle_frequency := 0.1
@export var path_to_level: String

var _current_output_length := 0
var _t := 0.0

var _display_label: RichTextLabel:
	get: return $InfoLayer/MarginContainer/VBoxContainer/DisplayLabel

var _hidden_label: RichTextLabel: 
	get: return $InfoLayer/HiddenLabel

var _morse_player: AudioStreamPlayer:
	get: return $MorsePlayer

var _parallax_background: ParallaxBackgroundLayer:
	get: return $ParallaxBackground

var _fader: ColorRect:
	get: return $FadeToBlackLayer/Fader

var _fader_layer: CanvasLayer:
	get: return $FadeToBlackLayer

var _parsed_output_length := 0

var _fading := false
var _t_fading := 0.0
var _showing_all_text := false

func _ready() -> void:
	_parallax_background.tile_h_count = tile_h_count
	_parallax_background.gradient_texture = gradient_texture
	_parallax_background.resample_chance = resample_chance
	_parallax_background.cycle_frequency = cycle_frequency
	_hidden_label.text = intro_text
	_parsed_output_length = _hidden_label.get_parsed_text().length()
	_display_label.text = intro_text
	_display_label.visible_characters = 0
	_morse_player.stream = intro_morse
	_morse_player.play()


func _physics_process(delta: float) -> void:
	_t += delta
	_current_output_length = floor(_t * characters_per_second)
	if !_showing_all_text and _current_output_length < _parsed_output_length:
		_display_label.visible_characters = _current_output_length
	else:
		_showing_all_text = true
		_display_label.visible_characters = -1
		if _morse_player.playing:
			_morse_player.stop()

	if Input.is_action_just_released("ui_accept"):
		if !_showing_all_text:
			_showing_all_text = true
		elif !_fading:
			_continue_to_level()

	if _fading:
		_t_fading += delta
		if _t_fading > fade_time_seconds:
			_done()
		_fader.modulate.a = _t_fading / fade_time_seconds

func _on_morse_player_finished() -> void:
	if _current_output_length < _parsed_output_length:
		_morse_player.play()

func _continue_to_level() -> void:
	_fader_layer.show()
	_fading = true

func _done() -> void:
	_morse_player.stop()
	get_tree().change_scene_to_file(path_to_level)
