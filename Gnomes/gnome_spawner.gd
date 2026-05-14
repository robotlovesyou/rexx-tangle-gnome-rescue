extends Node2D

@export var respawn := true
@export var gnome_scene: PackedScene
var _gnome: Gnome

func _ready() -> void:
	for child in get_children():
		if child.is_in_group("Gnome"):
			_gnome = child as Gnome
			child.reparent.call_deferred(get_parent())
			_gnome.prepare_appear()
			_gnome.appear()


func _on_gnome_died() -> void:
	if !_gnome.saved:
		_respawn_gnome()
	
func _respawn_gnome() -> void:
	_gnome = gnome_scene.instantiate() as Gnome
	_gnome.prepare_appear()
	get_parent().add_child(_gnome)
	_gnome.global_position = global_position
	_gnome.connect("died", _on_gnome_died)
	_gnome.appear()
