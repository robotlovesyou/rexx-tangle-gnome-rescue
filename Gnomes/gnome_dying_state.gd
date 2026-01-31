class_name GnomeDyingState
extends GnomeState

var _gnome: Gnome

func state_id() -> StateID: return StateID.DYING

func _init(gnome: Gnome):
	_gnome = gnome

func on_enter_state() -> void:
	FollowersMonitor.remove_safe(_gnome)
	_gnome.collision_layer = 0
	_gnome.queue_free()