extends Node2D


class TitleCharacter:
	var _char
	var char: String:
		get: return _char

	var _color: Color
	var color: Color: 
		get: return _color
		set(val): _color = val

	func _init(init_char: String, init_color: Color):
		_char = init_char
		_color = init_color

	func to_bbcode() -> String:
		return " " if _char == " " else "[color=\"#%s\"]%s[/color]" % [_color.to_html(false), _char]

@export var switch_action_probability := 0.05
@export var min_time_between_switches := 1.5
@export var movement_config: PlayerMovementConfig
@export var title_label: RichTextLabel
@export var title_color_change_chance = 0.001
@export var title_gradient: GradientTexture1D
@export var title_cycle_frequency := 0.1
@export var new_game_button: Button
@export var quit_button: Button
@export var next_scene: String

var _title_1_chars: Array[TitleCharacter] = []
var _title_2_chars: Array[TitleCharacter] = []

var _menu_music: AudioStreamPlayer: 
	get: return $MenuMusic

var _cutscene_rexx: CutsceneRexx:
	get: return $CutsceneRexx

var _menu_background: MenuBackground:
	get: return $MenuBackground

var _move_right := true
var _tile_wh := 0.0
var _current_row := 0
var _is_walking := false
var _time_since_last_switch := min_time_between_switches
var _t := 0.0

func _ready() -> void:
	_tile_wh = get_viewport_rect().size.x / float(_menu_background.tile_h_count)
	_move_to_start_of_row(0)
	_walk_rexx()
	_cutscene_rexx.disable_camera()
	for c in ["R", "E", "X", "X", "I", " ", "T", "A", "N", "G", "L", "E", ":"]:
		_title_1_chars.append(TitleCharacter.new(c, _sample_from_gradient(randf())))

	for c in ["G", "N", "O", "M", "E", " ", "R", "E", "S", "C", "U", "E", "!"]:
		_title_2_chars.append(TitleCharacter.new(c, _sample_from_gradient(randf())))

	new_game_button.grab_focus()

	title_label.text = _title_chars_to_bbcode()

func _physics_process(delta: float) -> void:
	_t += delta
	_time_since_last_switch += delta

	if _time_since_last_switch >= min_time_between_switches and randf() <= switch_action_probability:
		if _is_walking:
			_idle_rexx()
		else:
			_walk_rexx()

	var velocity_x := movement_config.SPEED * delta
	if !_move_right: velocity_x *= -1.0

	if _is_walking:
		_cutscene_rexx.position.x += velocity_x

	if _has_completed_row():
		_current_row += 1
		if _move_right:
			_move_to_end_of_row(_current_row)
		else:
			_move_to_start_of_row(_current_row)

	if _has_completed_screen():
		print("has completed screen")
		_current_row = 0
		_move_to_start_of_row(_current_row)

	var title_did_change = false

	for c in _title_1_chars:
		if randf() <= title_color_change_chance:
			c.color = _sample_from_gradient(0.5 + 0.5 * sin(2.0 * PI * title_cycle_frequency * _t))
			title_did_change = true

	for c in _title_2_chars:
		if randf() <= title_color_change_chance:
			c.color = _sample_from_gradient(0.5 + 0.5 * sin(2.0 * PI * title_cycle_frequency * _t))
			title_did_change = true

	if title_did_change:
		title_label.text = _title_chars_to_bbcode()

func _sample_from_gradient(f: float) -> Color:
	return title_gradient.gradient.sample(f)

func _on_quit_to_desktop_clicked() -> void:
	print("quit")

func _on_new_game_clicked() -> void:
	print("new game")


func _on_menu_music_finished() -> void:
	_menu_music.play()

func _idle_rexx() -> void:
	_cutscene_rexx.idle()
	_is_walking = false
	_time_since_last_switch = 0.0

func _walk_rexx() -> void:
	_cutscene_rexx.walk()
	_is_walking = true
	_time_since_last_switch = 0.0

func _move_to_start_of_row(row: int) -> void:
	_cutscene_rexx.position = Vector2(-1.5 * _tile_wh, (row + 0.5) * _tile_wh)
	_move_right = true
	_cutscene_rexx.face_right()
	# _idle_rexx()

func _move_to_end_of_row(row: int) -> void:
	_cutscene_rexx.position = Vector2((_menu_background.tile_h_count + 1.5) * _tile_wh, (row + 0.5) * _tile_wh)
	_move_right = false
	_cutscene_rexx.face_left()
	# _idle_rexx()

func _has_completed_row() -> bool:
	return (
		(_move_right and _cutscene_rexx.position.x > (_menu_background.tile_h_count + 2.5) * _tile_wh)
		or 
		(!_move_right and _cutscene_rexx.position.x < -2.5 * _tile_wh)
	)

func _has_completed_screen() -> bool: return _current_row > get_viewport_rect().size.y / _tile_wh

func _title_chars_to_bbcode() -> String:
	var title = ""
	for c in _title_1_chars:
		title += c.to_bbcode()
	
	title += "\n"
	
	for c in _title_2_chars:
		title += c.to_bbcode()

	return title


func _on_new_game_button_pressed() -> void:
	Level.replace_level_with(next_scene)
