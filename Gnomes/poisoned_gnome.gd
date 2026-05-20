class_name PoisonedGnome
extends Node2D

const LIFE_TIME_SECONDS := 1.0

var _t := 0.0

func _physics_process(delta: float) -> void:
	_t += delta
	if _t >= LIFE_TIME_SECONDS:
		self.queue_free()

var animation_player: AnimationPlayer:
	get: return $AnimationPlayer
	
var burn_effect_player: AudioStreamPlayer2D:
	get: return $BurnEffectPlayer
	
func _ready() -> void:
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()
	animation_player.play("poison")
	burn_effect_player.play()
