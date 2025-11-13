extends Node2D

@export var animation_player: AnimationPlayer
@export var rexx: CutsceneRexx
@export var birb_player: AudioStreamPlayer2D
@export var next_screen: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("rexx_enters_stage_left")	


func _on_muffle_exterior_sounds_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("CutsceneRexx"):
		birb_player.bus = "OutsideFromInside"

func start_next_level() -> void:
	Level.replace_level_with(next_screen)
