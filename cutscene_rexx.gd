class_name CutsceneRexx
extends Node2D

@export var animation_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("walk")

func walk() -> void:
	animation_player.play("walk")

func idle() -> void:
	animation_player.play("idle")
