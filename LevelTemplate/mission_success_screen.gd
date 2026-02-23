@tool
class_name MissionSuccessScreen
extends Node2D

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

var _parallax_background: ParallaxBackground:
	get: return $ParallaxBackground

@export var fireworks_gpu_particles: Array[PackedScene]
@export var spawn_chance := 1.0/60.0
@export var next_scene_path: String
@export var exit_disabled_seconds := 1.0
var _t := 0.0

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		_t += delta
		if randf() <= spawn_chance:
			var w = get_viewport().get_visible_rect().size.x
			var h = get_viewport().get_visible_rect().size.y
			var x = randi_range(0, w)
			var y = randi_range(0, h)
			var firework = fireworks_gpu_particles.pick_random().instantiate() as GPUParticles2D
			add_child(firework)
			firework.position.x = x
			firework.position.y = y
			firework.restart()

		if Input.is_action_just_released("ui_accept") and _t >= exit_disabled_seconds:
			_change_to_next_scene()


func _change_to_next_scene() -> void:
	get_tree().change_scene_to_file(next_scene_path)	


func _on_button_pressed() -> void:
	_change_to_next_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
