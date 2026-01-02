class_name WalkEffectPlayer
extends EffectPlayer

var _playing := false

func play() -> void:
	if _playing: return
	_playing = true
	_play_next_part()

func stop() -> void:
	_playing = false

func on_audio_player_finished() -> void:
	if _playing:
		_play_next_part()

func _play_next_part() -> void:
	var pitch = randf_range(_min_pitch, _max_pitch)
	var volume = randf_range(_min_volume, _max_volume)
	var part = _select_next_stream()
	_audio_player.stream = part
	_audio_player.pitch_scale = pitch
	_audio_player.volume_db = volume
	_audio_player.play()
