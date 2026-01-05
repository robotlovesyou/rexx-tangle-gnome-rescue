class_name GnomeOrphanedState
extends GnomeState

var _gnome: Gnome

func state_id() -> StateID: return StateID.ORPHANED

func _init(gnome: Gnome):
	_gnome = gnome

func on_physics_process(delta: float) -> void:
	if not _gnome.is_on_floor():
		_gnome.velocity += _gnome.get_gravity() * delta

	_gnome.move_and_slide()
