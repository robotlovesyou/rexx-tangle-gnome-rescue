class_name EffectPlayer
extends RefCounted

const DEFAULT_MIN_PITCH := 1.4
const DEFAULT_MAX_PITCH := 1.6
const DEFAULT_MIN_VOLUME := -12.5
const DEFAULT_MAX_VOLUME := -9.5

const MIN_PITCH := "min_pitch"
const MAX_PITCH := "max_pitch"
const MIN_VOLUME := "min_volume"
const MAX_VOLUME := "max_volume"

var _audio_player: AudioStreamPlayer2D
var _sounds: Array[AudioStreamWAV]
var _min_pitch := 0.0
var _max_pitch := 0.0
var _min_volume := 0.0
var _max_volume := 0.0

var playing: bool:
	get: return _audio_player.playing

func _init(audio_player: AudioStreamPlayer2D, sounds: Array[AudioStreamWAV], options: Dictionary[String, float] = {}):
	_audio_player = audio_player
	_sounds = sounds
	_min_pitch = options[MIN_PITCH] if MIN_PITCH in options else DEFAULT_MIN_PITCH
	_max_pitch = options[MAX_PITCH] if MAX_PITCH in options else DEFAULT_MAX_PITCH
	_min_volume = options[MIN_VOLUME] if MIN_VOLUME in options else DEFAULT_MIN_VOLUME
	_max_volume = options[MAX_VOLUME] if MAX_VOLUME in options else DEFAULT_MAX_VOLUME



func play() -> void:
	var pitch = randf_range(_min_pitch, _max_pitch)
	var volume = randf_range(_min_volume, _max_volume)
	var part = _select_next_stream()
	_audio_player.stream = part
	_audio_player.pitch_scale = pitch
	_audio_player.volume_db = volume
	_audio_player.play()

func _select_next_stream() -> AudioStreamWAV:
	return _sounds.pick_random()
