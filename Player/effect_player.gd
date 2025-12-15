class_name EffectPlayer
extends RefCounted

const MIN_PITCH := 1.4
const MAX_PITCH := 1.6
const MIN_VOLUME := -12.5
const MAX_VOLUME := -9.5

var _audio_player: AudioStreamPlayer2D
var _sounds: Array[AudioStreamWAV]

var playing: bool:
	get: return _audio_player.playing

func _init(audio_player: AudioStreamPlayer2D, sounds: Array[AudioStreamWAV]):
	_audio_player = audio_player
	_sounds = sounds

func play() -> void:
	var pitch = randf_range(MIN_PITCH, MAX_PITCH)
	var volume = randf_range(MIN_VOLUME, MAX_VOLUME)
	var part = _select_next_stream()
	_audio_player.stream = part
	_audio_player.pitch_scale = pitch
	_audio_player.volume_db = volume
	_audio_player.play()

func _select_next_stream() -> AudioStreamWAV:
	return _sounds.pick_random()