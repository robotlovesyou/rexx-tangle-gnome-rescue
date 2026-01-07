class_name HUD
extends CanvasLayer

signal hilight_gnome_count_done
signal hilight_timer_done

@export var gnome_count: HBoxContainer
@export var gnome_label: RichTextLabel
@export var flash_gnome_count: ColorRect
@export var timer: HBoxContainer
@export var timer_label: RichTextLabel
@export var flash_timer: ColorRect
@export var flash_time_seconds: float = 2.0

var _flashing_gnome_count := false
var _time_flashing_gnome_count := 0.0

var _flashing_timer := false
var _time_flashing_timer := 0.0

func update_gnome_count(rescued: int, minimum: int, remaining: int) -> void:
	var rescued_color = "red" if rescued < minimum else "green"
	var remaining_color = "red" if rescued + remaining < minimum else "green"
	gnome_label.text = "Rescued: [color=\"%s\"]%d/%d[/color] Remaining: [color=\"%s\"]%d[/color]" % [rescued_color, rescued, minimum, remaining_color, remaining]

func update_timer(seconds: int) -> void:
	var timer_color = "green" if seconds >= 60 else "red"
	var minutes := int(floor(seconds / 60.0))
	var remaining_seconds = seconds - (minutes * 60)
	timer_label.text = "[color=\"%s\"]%d:%02d[/color]" % [timer_color, minutes, remaining_seconds]

func hide_gnome_count() -> void:
	gnome_count.modulate.a = 0.0

func show_gnome_count() -> void:
	gnome_count.modulate.a = 1.0

func hilight_gnome_count() -> void:
	_flashing_gnome_count = true
	_time_flashing_gnome_count = 0.0

func hide_timer() -> void:
	timer.modulate.a = 0.0

func show_timer() -> void:
	timer.modulate.a = 1.0

func hilight_timer() -> void:
	_flashing_timer = true
	_time_flashing_timer = 0.0

func _physics_process(delta: float) -> void:
	if _flashing_gnome_count:
		_time_flashing_gnome_count += delta
		flash_gnome_count.visible = int(floor((4.0 * _time_flashing_gnome_count))) % 2 == 0

	if _flashing_gnome_count and _time_flashing_gnome_count > flash_time_seconds:
		_flashing_gnome_count = false
		flash_gnome_count.visible = false
		hilight_gnome_count_done.emit()

	if _flashing_timer:
		_time_flashing_timer += delta
		flash_timer.visible = int(floor((4.0 * _time_flashing_timer))) % 2 == 0

	if _flashing_timer and _time_flashing_timer > flash_time_seconds:
		_flashing_timer = false
		flash_timer.visible = false
		hilight_timer_done.emit()
