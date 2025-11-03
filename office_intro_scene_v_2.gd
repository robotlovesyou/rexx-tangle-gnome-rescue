extends Node2D

@export var animation_player: AnimationPlayer
@export var rexx: CutsceneRexx


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("rexx_enters_stage_left")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
