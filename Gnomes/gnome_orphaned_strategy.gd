class_name GnomeOrphanedStrategy
extends GnomeStrategy

var _gnome: Gnome

func state_id() -> StateID: return StateID.ORPHANED

func _init(gnome: Gnome):
	_gnome = gnome

func on_enter_state() -> void:
	FollowersMonitor.remove(_gnome)

func on_physics_process(delta: float) -> void:
	if not _gnome.is_on_floor():
		_gnome.velocity += _gnome.get_gravity() * delta
	else:
		_gnome.velocity.x = 0.0 #Don't walk around and get yourself killed when orphaned

	_gnome.move_and_slide()
