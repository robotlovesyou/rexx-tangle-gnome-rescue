class_name FireProjectile
extends CharacterBody2D

const FRAME_COUNT := 4.0
const FINAL_ENERGY := 1.0
const INITIAL_PITCH := 1.8
const FINAL_PITCH := 0.5
const INITIAL_VOLUME := -6.0
const FINAL_VOLUME := -12.0
const FADE_TIME_PROPORTION := 0.1
var life_time_seconds := 10.0
var _charge := 0.0
var _t := 0.0
var _fired := false
var _dying := false

var projectile_sprite: Sprite2D:
	get: return $ProjectileSprite
	
var projectile_light: PointLight2D:
	get: return $ProjectileLight
	
var collision_area: Area2D:
	get: return $CollisionArea
	
var burn_fx_player: AudioStreamPlayer2D:
	get: return $BurnFxPlayer
	
func _ready() -> void:
	velocity = Vector2.ZERO
		
func set_charge(charge: float) -> void:
	_charge = min(charge, 1.0)

func _physics_process(delta: float) -> void:
	
	projectile_sprite.frame = int(floor(_charge * (FRAME_COUNT -1)))
	projectile_light.energy = _charge * FINAL_ENERGY
	projectile_sprite.rotate(PI * delta)
	
	if _fired:
		_t += delta	
		move_and_slide()
		if _t >= life_time_seconds:
			queue_free()
		
func pre_fire(v: Vector2, t: float) -> void:
	_t += t
	_charge = 1.0
	fire(v)
		
func fire(v: Vector2) -> void:
	velocity = v
	var time_proportion := (life_time_seconds - _t) / life_time_seconds
	position += _t * v
	_fired = true
	burn_fx_player.play()
	burn_fx_player.volume_db = INITIAL_VOLUME - ((INITIAL_VOLUME - FINAL_VOLUME) * time_proportion)
	burn_fx_player.pitch_scale = INITIAL_PITCH - ((INITIAL_PITCH - FINAL_PITCH) * time_proportion)
	var tween_time := life_time_seconds - _t
	create_tween().tween_property(burn_fx_player, "pitch_scale", FINAL_PITCH, tween_time)
	create_tween().tween_property(burn_fx_player, "volume_db", FINAL_VOLUME, tween_time)
	get_tree().create_timer((1.0 - FADE_TIME_PROPORTION) * tween_time).timeout.connect(_start_projectile_death)
	
	for body in collision_area.get_overlapping_bodies():
		_on_collision_area_body_entered(body)
	
		
func _start_projectile_death() -> void:
	_dying = true
	create_tween()\
		.tween_property(projectile_light, "energy", 0.0, life_time_seconds - _t)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)
	
	var transparent = projectile_sprite.modulate
	modulate.a = 0.0
	create_tween()\
		.tween_property(projectile_sprite, "modulate", transparent, life_time_seconds - _t)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)
	
func _on_collision_area_body_entered(body: Node2D) -> void:
	if not _fired or _dying: return
	
	if body is Player:
		Events.player_burned_async()
	elif body is Gnome:
		Events.gnome_burned_async(body as Gnome)
