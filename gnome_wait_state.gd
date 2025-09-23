class_name GnomeWaitState\
extends GnomeState

var _gnome: Gnome

func _init(gnome: Gnome):
	_gnome = gnome

func state_id() -> StateID:
	return StateID.WAITING

func on_animate(_sprite: AnimatedSprite2D) -> void:
	_sprite.play("idle")
