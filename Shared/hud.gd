class_name HUD
extends CanvasLayer

signal hilight_gnome_count_done
signal hilight_timer_done
signal hilight_minimap_done

@export var gnome_count: HBoxContainer
@export var gnome_label: RichTextLabel
@export var flash_gnome_count: ColorRect
@export var timer: HBoxContainer
@export var timer_label: RichTextLabel
@export var flash_timer: ColorRect
@export var flash_time_seconds: float = 2.0
@export var minimap: ColorRect
@export var minimap_default_color: Color = Color.BLACK
@export var minimap_flash_color: Color = Color.WHITE
@export var flash_sandwich:  ColorRect
@export var sandwich_label: RichTextLabel
@export var flash_coins: ColorRect
@export var coins_label: RichTextLabel

var _flashing_gnome_count := false
var _time_flashing_gnome_count := 0.0

var _flashing_timer := false
var _time_flashing_timer := 0.0

var _flashing_minimap := false
var _time_flashing_minimap := 0.0

var _encountered_gnomes: Dictionary[int, int] = {}
var _reported_gnomes: Array = []
var _level_bounds: Rect2

func report_gnome_location(id: int, location: Vector2) -> void:
	if !_encountered_gnomes.has(id):
		_encountered_gnomes[id] = Time.get_ticks_msec()
	
	_reported_gnomes.append([id, location])
	
func set_level_bounds(bounds: Rect2) -> void:
	_level_bounds = bounds

func update_gnome_count(rescued: int, minimum: int, remaining: int) -> void:
	var rescued_color = "red" if rescued < minimum else "green"
	var remaining_color = "red" if rescued + remaining < minimum else "green"
	gnome_label.text = "Rescued: [color=\"%s\"]%d/%d[/color] Remaining: [color=\"%s\"]%d[/color]" % [rescued_color, rescued, minimum, remaining_color, remaining]

func update_timer(seconds: int) -> void:
	var timer_color = "green" if seconds >= 60 else "red"
	var minutes := maxi(0, int(floor(seconds / 60.0)))
	var remaining_seconds = maxi(0, seconds - (minutes * 60))
	timer_label.text = "[color=\"%s\"]%d:%02d[/color]" % [timer_color, minutes, remaining_seconds]
	
func update_sandwich_count(count: int) -> void:
	sandwich_label.text = "[color=\"green\"]%d[/color]" % [count]
	
func update_coin_count(count: int) -> void:
	coins_label.text = "[color=\"green\"]%d[/color]" % [count]

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
	
func hide_minimap() -> void:
	minimap.hide()
	
func show_minimap() -> void:
	minimap.show()
	
func hilight_minimap() -> void:
	_flashing_minimap = true
	_time_flashing_minimap = 0.0

func _physics_process(delta: float) -> void:
	if _flashing_gnome_count:
		_time_flashing_gnome_count += delta
		flash_gnome_count.visible = int(floor(4.0 * _time_flashing_gnome_count)) % 2 == 0
		if _time_flashing_gnome_count > flash_time_seconds:
			_flashing_gnome_count = false
			flash_gnome_count.visible = false
			hilight_gnome_count_done.emit()

	if _flashing_timer:
		_time_flashing_timer += delta
		flash_timer.visible = int(floor((4.0 * _time_flashing_timer))) % 2 == 0
		if _time_flashing_timer > flash_time_seconds:
			_flashing_timer = false
			flash_timer.visible = false
			hilight_timer_done.emit()
		
	if _flashing_minimap:
		_time_flashing_minimap += delta
		minimap.color = minimap_flash_color if int(floor(4.0 * _time_flashing_minimap)) % 2 == 0 else minimap_default_color
		if _time_flashing_minimap > flash_time_seconds:
			_flashing_minimap = false
			minimap.color = minimap_default_color
			hilight_minimap_done.emit()
			
	for child in minimap.get_children():
		if !child is ColorRect: return
		
		var pt = child as ColorRect
		pt.hide()
		pt.queue_free()
	
	var cr: ColorRect	
	for reported_gnome in _reported_gnomes:
		var reported_pos = reported_gnome[1] as Vector2
		cr = ColorRect.new()
		cr.color = Color.AQUAMARINE
		cr.size = Vector2(2.0, 2.0)
		minimap.add_child(cr)
		cr.position = _position_to_minimap_position(reported_pos)
		
	cr = ColorRect.new()
	cr.color = Color.RED
	cr.size = Vector2(2.0, 2.0)
	minimap.add_child(cr)
	cr.position = _position_to_minimap_position(PMonitor.player.global_position)
	
	_reported_gnomes.clear()
	
func _position_to_minimap_position(reported_pos: Vector2) -> Vector2:
	return Vector2(((reported_pos.x - _level_bounds.position.x) / _level_bounds.size.x) * minimap.size.x, ((reported_pos.y - _level_bounds.position.y) / _level_bounds.size.y) * minimap.size.y)
		
