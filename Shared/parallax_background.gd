class_name ParallaxBackgroundLayer
extends Node2D

@export var tile_h_count := 16
@export var gradient_texture: GradientTexture1D
@export var resample_chance := 0.1
@export var cycle_frequency := 1.0

var _tiles: Array[ColorRect] = []
var _lines: Array[Line2D] = []
var _t := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_rect := get_viewport_rect()
	var tile_wh := viewport_rect.size.x / tile_h_count
	var tile_v_count := ceil(viewport_rect.size.y / tile_wh) as int
	for i in range(tile_h_count):
		for j in range(tile_v_count):
			var cr := ColorRect.new()
			cr.size = Vector2(tile_wh, tile_wh)
			cr.position = Vector2(i * tile_wh, j * tile_wh)
			cr.color = gradient_texture.gradient.sample(randf())
			add_child(cr)
			_tiles.append(cr)

	for i in range(tile_h_count):
		var l = Line2D.new()
		l.points = [Vector2(i * tile_wh, 0), Vector2(i * tile_wh, viewport_rect.size.y)]
		l.default_color = Color.WHITE
		l.width = 2.0
		add_child(l)
		_lines.append(l)

	for i in range(tile_v_count):
		var l = Line2D.new()
		l.points = [Vector2(0, i * tile_wh), Vector2(viewport_rect.size.x, i * tile_wh)]
		l.default_color = Color.WHITE
		l.width = 2.0
		add_child(l)
		_lines.append(l)


func _color_at(t: float, p: float = 0.0) -> Color: return gradient_texture.gradient.sample(0.5 + 0.5 * sin(2.0 * PI * cycle_frequency * _t + p))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_t += delta
	for cr in _tiles:
		if(randf() <= resample_chance):
			cr.color = _color_at(_t, PI)
	
	for l in _lines:
		l.default_color = _color_at(_t)
