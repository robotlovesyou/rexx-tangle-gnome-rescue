class_name BurningRexx
extends Node2D

const FRAME_HEIGHT := 32.0
const BURN_TIME := 0.8
const TIME_UNTIL_DONE := 8.0 * BURN_TIME
const BURN_WIDTH := 0.05
var _t := 0.0
var _done := false

var animation: AnimatedSprite2D:
	get: return $Animation

var burn_particles: GPUParticles2D: 
	get: return $BurnParticles
	
var burn_player: AudioStreamPlayer2D:
	get: return $BurnPlayer
	
var burn_light: PointLight2D:
	get: return $BurnLight
	
var flip_h: bool:
	get: return animation.flip_h
	set(value): animation.flip_h = value
	
func set_burn_amount(amount: float) -> void:
	amount = min(amount, 1.0)
	burn_particles.position.y = (FRAME_HEIGHT * (1.0 - amount)) - (FRAME_HEIGHT / 2.0)
	burn_light.position.y = (FRAME_HEIGHT * (1.0 - amount)) - (FRAME_HEIGHT / 2.0)
	animation.material.set_shader_parameter("burn_amount", amount)
	
func stop_burn() -> void:
	burn_particles.emitting = false
	burn_light.enabled = false
	
func set_hide_amount(amount: float) -> void:
	amount = min(amount, 1.0)
	animation.material.set_shader_parameter("hide_amount", amount)
	
func set_flame_amount(amount: float) -> void:
	amount = min(amount, 1.0)
	animation.material.set_shader_parameter("flame_amount", amount)
	
func _ready() -> void:
	burn_player.play()
	burn_particles.emitting = true
	burn_particles.restart()
	burn_light.enabled = true
	create_tween()\
		.tween_property(burn_light, "energy", 0.0, BURN_TIME * 1.5)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	burn_light.enabled = true
	burn_particles.position.y = FRAME_HEIGHT / 2.0
	burn_light.position.y = FRAME_HEIGHT / 2.0
	set_flame_amount(0.0)
	set_burn_amount(0.0)
	set_hide_amount(0.0)
	
func _physics_process(delta: float) -> void:
	_t += delta
	
	if _done and _t >= TIME_UNTIL_DONE:
		queue_free()
		
	if _done: return
	
	var amount = _t / BURN_TIME
	
	if _t > BURN_TIME:
		_done = true
		stop_burn()
		set_flame_amount(1.0)
		set_burn_amount(1.0)
		set_hide_amount(1.0)	
		
	if not _done:
		set_flame_amount(amount)
		set_burn_amount(amount - BURN_WIDTH)
		set_hide_amount(amount - 2.0 * BURN_WIDTH)
	
	
