extends Node2D

var _is_paused := false

var dialog_layer: CutsceneDialogLayer:
	get: return $DialogLayer
	
var cutscene_player: AnimationPlayer:
	get: return $CutscenePlayer
	
var cutscene_rexx: CutsceneRexx:
	get: return $CutsceneRexx
	
var rexx_face_on: Sprite2D:
	get: return $RexxFaceOn
	
var mama_tangle: AnimatedSprite2D:
	get: return $MamaTangle
	
var mama_face_on: Sprite2D:
	get: return $MamaFaceOn
	
@export var rexx_portrait_path: String
@export var rexx_portrait_name: String
@export var mama_portrait_path: String
@export var mama_portrait_name: String
@export var both_portrait_path: String
@export var both_portrait_name: String
@export var next_screen: String

func show_mama_dialog_1() -> void:
	dialog_layer.open("Rexxi! I'm sick of you festering in this basement. You need to go out and get a job!", mama_portrait_path, mama_portrait_name)
	
func show_mama_dialog_2() -> void:
	dialog_layer.open("Nonsense child! Gnomenclature are hiring Gnome Intervention Technicians. Gnomes are [wave freq=10]terrified[/wave] of Robots!", mama_portrait_path, mama_portrait_name)
	
func show_rexxi_dialog_1() -> void:
	dialog_layer.open("But Maaam! No Jaaahb! Robots took'em all!", rexx_portrait_path, rexx_portrait_name)
	
func show_rexxi_dialog_2() -> void:
	dialog_layer.open("But Maaam! Why would gnomes be terrified of an invention whose sole purpose is to reduce the economic value of our labor to zero?", rexx_portrait_path, rexx_portrait_name) 
	
func show_rexxi_dialog_3() -> void:
	dialog_layer.open("OK Maam. I get job as GIT.", rexx_portrait_path, rexx_portrait_name)
	
func show_both_dialog() -> void:
	dialog_layer.open("Silly Gnomes!", both_portrait_path, both_portrait_name)
	
func start_next_level() -> void:
	Level.replace_level_with(next_screen)
	
func close_dialog() -> void:
	dialog_layer.close()
	
func show_face_on() -> void:
	cutscene_rexx.hide()
	mama_tangle.hide()
	rexx_face_on.show()
	mama_face_on.show()
	
func hide_face_on() -> void:
	cutscene_rexx.show()
	mama_tangle.show()
	rexx_face_on.hide()
	mama_face_on.hide()


func _on_dialog_layer_pause_requested() -> void:
	cutscene_player.pause()
	_is_paused = true
	
func _physics_process(_delta: float) -> void:
	if _is_paused and Input.is_action_just_pressed("ui_accept"):
		cutscene_player.play()
		_is_paused = false
