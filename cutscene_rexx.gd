class_name CutsceneRexx
extends Node2D

@export var animation_player: AnimationPlayer
@export var pitter_patter: Array[AudioStreamWAV]
@export var pitter_patter_player: AudioStreamPlayer2D

const MIN_PITCH := 1.4
const MAX_PITCH := 1.6
const MIN_VOLUME := -12.5
const MAX_VOLUME := -9.5

var _is_playing_pitter_patter: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walk()

func walk() -> void:
	animation_player.play("walk")
	_is_playing_pitter_patter = true
	_play_next_part()

func idle() -> void:
	animation_player.play("idle")
	_is_playing_pitter_patter = false


func _on_pitter_patter_player_finished() -> void:
	if _is_playing_pitter_patter:
		_play_next_part()

func _start_pitter_patter_player() -> void:
	pass

func _stop_pitter_patter_player() -> void:
	pass

func _play_next_part() -> void:
	var pitch = randf_range(MIN_PITCH, MAX_PITCH)
	var volume = randf_range(MIN_VOLUME, MAX_VOLUME)
	var part = _select_next_stream()
	pitter_patter_player.stream = part
	pitter_patter_player.pitch_scale = pitch
	pitter_patter_player.volume_db = volume
	pitter_patter_player.play()

func _select_next_stream() -> AudioStreamWAV:
	return pitter_patter.pick_random()
