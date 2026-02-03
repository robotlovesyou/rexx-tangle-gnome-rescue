extends TileMapLayer

var _beat_envelope := ADEnvelope.new(0.05, 0.1)

func _ready() -> void:
	Events.beat_channel_1.connect(_trigger_beat_effect)

func _physics_process(delta: float) -> void:
	_beat_envelope.progress(delta)
	material.set_shader_parameter("envelope_value", _beat_envelope.sample())

func _trigger_beat_effect() -> void:
	_beat_envelope.trigger()
