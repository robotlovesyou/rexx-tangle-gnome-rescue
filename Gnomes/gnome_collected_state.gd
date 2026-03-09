class_name GnomeCollectedState
extends GnomeState

var _gnome: Gnome

func state_id() -> StateID: return StateID.COLLECTED

func _init(gnome: Gnome):
	_gnome = gnome

func on_enter_state() -> void:
	_gnome.gnome_was_rescued.call_deferred()
	_gnome.play_hello_once()
	var i = FollowersMonitor.add(_gnome)
	_gnome.collection_complete.call_deferred(i)

func on_exit_state() -> void:
	pass
