extends Node2D

@export var respawn := true
@export var gnome_scene: PackedScene

func _ready() -> void:
	for child in get_children():
		if child.is_in_group("Gnome"):
			var gnome = child as Gnome
			child.reparent.call_deferred(get_parent())
			gnome.prepare_appear()
			gnome.appear()
			gnome.connect("died", _on_gnome_died)


func _on_gnome_died() -> void:
	print("my gnome died")
	_respawn_gnome()
	
func _respawn_gnome() -> void:
	var gnome = gnome_scene.instantiate() as Gnome
	gnome.prepare_appear()
	get_parent().add_child(gnome)
	gnome.global_position = global_position
	gnome.connect("died", _on_gnome_died)
	gnome.appear()
