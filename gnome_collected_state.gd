class_name GnomeCollectedState
extends GnomeState

var _gnome: Gnome

func state_id() -> StateID: return StateID.COLLECTED

func _init(gnome: Gnome):
	_gnome = gnome

func on_enter_state() -> void:
	print("entered collected state")
	var i = FollowersMonitor.add(_gnome)
	_gnome.collection_complete.call_deferred(i)

func on_exit_state() -> void:
	print("exited collected state")
