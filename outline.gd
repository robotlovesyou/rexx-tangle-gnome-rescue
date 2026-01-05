# File: VisibleRegionPreview2D.gd
@tool
extends Node2D
class_name VisibleRegionPreview2D

@export var outline_color: Color = Color(1.0, 0.3, 0.3, 1.0)
@export var outline_thickness: float = 2.0

# Preview window size selection
@export var use_test_size: bool = true
@export var simulate_window: bool = false
@export var simulated_window_size: Vector2i = Vector2i(1920, 1080)

var preview_rect: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)

# Godot 4 enum values
const STRETCH_MODE_DISABLED: int      = 0
const STRETCH_MODE_CANVAS_ITEMS: int  = 1   # aka "2d"
const STRETCH_MODE_VIEWPORT: int      = 2

const STRETCH_ASPECT_IGNORE: int      = 0
const STRETCH_ASPECT_KEEP: int        = 1
const STRETCH_ASPECT_KEEP_WIDTH: int  = 2
const STRETCH_ASPECT_KEEP_HEIGHT: int = 3
const STRETCH_ASPECT_EXPAND: int      = 4

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		set_process(true)
		_refresh_preview()
		queue_redraw()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_refresh_preview()
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint() and preview_rect.size.x > 0.0 and preview_rect.size.y > 0.0:
		# Origin-aligned rectangle (top-left = (0,0) in local coords)
		draw_rect(preview_rect, outline_color, false, outline_thickness)

func _refresh_preview() -> void:
	# Base logical (project) size
	var base_w: int = int(ProjectSettings.get_setting("display/window/size/viewport_width", 0))
	var base_h: int = int(ProjectSettings.get_setting("display/window/size/viewport_height", 0))
	if base_w <= 0 or base_h <= 0:
		preview_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
		return

	# Window size to simulate
	var win_w: int = 0
	var win_h: int = 0
	if use_test_size:
		win_w = int(ProjectSettings.get_setting("display/window/size/test_width", 0))
		win_h = int(ProjectSettings.get_setting("display/window/size/test_height", 0))

	if simulate_window:
		win_w = simulated_window_size.x
		win_h = simulated_window_size.y
	elif win_w <= 0 or win_h <= 0:
		win_w = int(ProjectSettings.get_setting("display/window/size/window_width", base_w))
		win_h = int(ProjectSettings.get_setting("display/window/size/window_height", base_h))

	# Stretch config (note: scale applies even if mode == disabled)
	var stretch_mode_value: int = int(ProjectSettings.get_setting("display/window/stretch/mode", STRETCH_MODE_DISABLED))
	var stretch_aspect_value: int = int(ProjectSettings.get_setting("display/window/stretch/aspect", STRETCH_ASPECT_KEEP))
	var stretch_scale_value: float = float(ProjectSettings.get_setting("display/window/stretch/scale", 1.0))

	var rect: Rect2 = _compute_visible_rect(
		stretch_mode_value,
		stretch_aspect_value,
		stretch_scale_value,
		base_w,
		base_h,
		win_w,
		win_h
	)
	preview_rect = rect

func _compute_visible_rect(
	stretch_mode_value: int,
	stretch_aspect_value: int,
	stretch_scale_value: float,
	base_w: int,
	base_h: int,
	win_w: int,
	win_h: int
) -> Rect2:
	var bw: float = float(base_w)
	var bh: float = float(base_h)
	var ww: float = float(win_w)
	var wh: float = float(win_h)

	# Origin-aligned rectangle (no centering offset; you asked for origin alignment)
	var pos: Vector2 = Vector2.ZERO
	var size: Vector2 = Vector2(bw, bh)

	# Pixel-per-project-unit scale components
	var sx_window: float = ww / bw
	var sy_window: float = wh / bh
	var s_scale: float = max(stretch_scale_value, 0.000001) # avoid div-by-zero

	if stretch_mode_value == STRETCH_MODE_DISABLED:
		# No auto-fit, but stretch/scale still applies uniformly.
		# Visible project area = window_pixels / (uniform_scale)
		var s_total_disabled: float = s_scale
		var vis_w_disabled: float = ww / s_total_disabled
		var vis_h_disabled: float = wh / s_total_disabled
		size = Vector2(vis_w_disabled, vis_h_disabled)
		return Rect2(pos, size)

	if stretch_mode_value == STRETCH_MODE_VIEWPORT:
		# Render to base viewport, then scale to window per aspect, then apply stretch_scale.
		match stretch_aspect_value:
			STRETCH_ASPECT_KEEP:
				# Logical area remains base, but stretch/scale reduces visible project units.
				size = Vector2(bw / s_scale, bh / s_scale)
			STRETCH_ASPECT_KEEP_WIDTH:
				# Fit width, then apply stretch scale.
				# Total uniform scale = sx_window * s_scale
				var s_total_kw: float = sx_window * s_scale
				size = Vector2(bw / s_scale, wh / s_total_kw)
			STRETCH_ASPECT_KEEP_HEIGHT:
				var s_total_kh: float = sy_window * s_scale
				size = Vector2(ww / s_total_kh, bh / s_scale)
			STRETCH_ASPECT_EXPAND:
				var s_fit_expand: float = min(sx_window, sy_window)
				var s_total_expand: float = s_fit_expand * s_scale
				size = Vector2(ww / s_total_expand, wh / s_total_expand)
			STRETCH_ASPECT_IGNORE:
				# Preview conservatively with uniform scale that keeps content visible
				var s_fit_ignore: float = min(sx_window, sy_window)
				var s_total_ignore: float = s_fit_ignore * s_scale
				size = Vector2(ww / s_total_ignore, wh / s_total_ignore)
		return Rect2(pos, size)

	# STRETCH_MODE_CANVAS_ITEMS (aka "2d")
	if stretch_mode_value == STRETCH_MODE_CANVAS_ITEMS:
		match stretch_aspect_value:
			STRETCH_ASPECT_KEEP:
				# Base stays base logically, but stretch/scale reduces visible area.
				size = Vector2(bw / s_scale, bh / s_scale)
			STRETCH_ASPECT_KEEP_WIDTH:
				# Fit width: total uniform scale = sx_window * s_scale
				var s_total_c_kw: float = sx_window * s_scale
				size = Vector2(bw / s_scale, wh / s_total_c_kw)
			STRETCH_ASPECT_KEEP_HEIGHT:
				var s_total_c_kh: float = sy_window * s_scale
				size = Vector2(ww / s_total_c_kh, bh / s_scale)
			STRETCH_ASPECT_EXPAND:
				var s_fit_c_exp: float = min(sx_window, sy_window)
				var s_total_c_exp: float = s_fit_c_exp * s_scale
				size = Vector2(ww / s_total_c_exp, wh / s_total_c_exp)
			STRETCH_ASPECT_IGNORE:
				# Use smaller uniform scale so nothing is cropped in preview
				var s_fit_c_ign: float = min(sx_window, sy_window)
				var s_total_c_ign: float = s_fit_c_ign * s_scale
				size = Vector2(ww / s_total_c_ign, wh / s_total_c_ign)
		return Rect2(pos, size)

	# Fallback
	size = Vector2(bw / s_scale, bh / s_scale)
	return Rect2(pos, size)
