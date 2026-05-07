@tool
class_name SpawnPoint
extends Node2D

var _active := false
@export var active: bool:
	get: return _active
	set(val): 
		if val:
			_activate_self()
		else:
			_deactivate_self()
			
@export var lit: bool = false

var _active_sprite: Sprite2D:
	get: return $SpawnPointActive

var _inactive_sprite: Sprite2D:
	get: return $SpawnPointInactive

var _active_particles: GPUParticles2D:
	get: return $ActiveParticles
	
var _glow: PointLight2D:
	get: return $Glow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if _active:
		_activate_self()
	else:
		_deactivate_self()
	

func _deactivate_other_spawn_points() -> void:
	if not is_inside_tree():
		return
		
	for point in get_tree().get_nodes_in_group("SpawnPoint"):
		if not point == self:
			(point as SpawnPoint).active = false
			
func _show_light_if_lit() -> void:
	if lit:
		_glow.show()
		
func _hide_light() -> void:
	_glow.hide()

func _activate_self() -> void:
	_active = true
	_active_sprite.visible = true
	_inactive_sprite.visible = false
	_active_particles.emitting = true
	_deactivate_other_spawn_points()
	_show_light_if_lit()
	if !Engine.is_editor_hint():
		Level.spawn_point = self

func _deactivate_self() -> void:
	_active = false
	_active_sprite.visible = false
	_inactive_sprite.visible = true
	_active_particles.emitting = false
	_hide_light()


func _on_activation_area_body_entered(body: Node2D) -> void:
	if body is Player and !_active:
		_activate_self()
