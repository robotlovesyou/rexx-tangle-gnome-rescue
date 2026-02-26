extends Node2D

@export var animation_player: AnimationPlayer
@export var rexx: CutsceneRexx
@export var birb_player: AudioStreamPlayer2D
@export var next_screen: String
@export var rexx_portrait_path: String
@export var rexx_portrait_name: String
@export var receptionist_portrait_path: String
@export var receptionist_portrait_name: String

var _dialog_layer: CutsceneDialogLayer:
	get: return $DialogLayer
	
var _is_paused := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("rexx_enters_stage_left")	


func _on_muffle_exterior_sounds_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("CutsceneRexx"):
		birb_player.bus = "OutsideFromInside"

func start_next_level() -> void:
	Level.replace_level_with(next_screen)
	
func show_rexx_dialog_1() -> void:
	_dialog_layer.open("Jaaaahb?", rexx_portrait_path, rexx_portrait_name)
	
func show_rexx_dialog_2() -> void:
	_dialog_layer.open("Yaah, jaaaahb!", rexx_portrait_path, rexx_portrait_name)
	
func show_receptionist_dialog_1() -> void:
	_dialog_layer.open("Yes, good morning Rexx. Welcome to [rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]Gnomenclature Inc[/rainbow]. Are you here to apply for employment as a 
[b][u]G[/u][/b]nome
[b][u]I[/u][/b]ntervention
[b][u]T[/u][/b]echnician?", receptionist_portrait_path, receptionist_portrait_name)

func show_receptionist_dialog_2() -> void:
	_dialog_layer.open("Certainly Rexx, Please proceed through the door behind me to commence your training", receptionist_portrait_path, receptionist_portrait_name)
	
func hide_dialog() -> void:
	_dialog_layer.close()

func _on_dialog_layer_pause_requested() -> void:
	animation_player.pause()
	_is_paused = true
	
func _physics_process(delta: float) -> void:
	if _is_paused and Input.is_action_just_released("ui_accept"):
		_is_paused = false
		animation_player.play()
