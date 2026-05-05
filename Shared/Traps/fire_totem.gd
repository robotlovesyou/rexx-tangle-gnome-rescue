class_name FireTotem
extends Node2D

const FRAME_COUNT = 4.0
var _t := 0.0
var _t_delay := 0.0
var _projectile: FireProjectile = null
var fire_vector := Vector2(-350.0, 0.0)

var totem_sprite: Sprite2D:
	get: return $TotemSprite

var projectile_anchor: Node2D:
	get: return $ProjectileAnchor

@export var cycle_time_seconds := 2.0
@export var delay_time_seconds := 0.0
@export var life_time_seconds := 10.0
@export var projectile_scene: PackedScene
@export var face_right := false
@export var pre_fire := true

func _add_fire_projectile() -> void:
	_projectile = projectile_scene.instantiate() as FireProjectile
	_projectile.life_time_seconds = life_time_seconds
	add_child(_projectile)
	_projectile.position = projectile_anchor.position
	
func _ready() -> void:
	_t_delay = 0.0
	if face_right:
		totem_sprite.flip_h = true
		projectile_anchor.position.x *= -1.0
		fire_vector *= -1.0
	if pre_fire:
		_pre_fire()
		
func _pre_fire() -> void:
	var pretime := life_time_seconds - delay_time_seconds
	while pretime > 0.0:
		_add_fire_projectile()
		if pretime >= cycle_time_seconds:
			pretime -= cycle_time_seconds
			_projectile.pre_fire(fire_vector, pretime)
			_projectile = null
			_add_fire_projectile()
		else:
			if pretime < delay_time_seconds:
				_t_delay += pretime
			else:
				_t_delay = delay_time_seconds
				_t += pretime
			pretime = 0.0
		
		
	print("delay_time: %f, _t_delay: %f, _t: %f" % [delay_time_seconds, _t_delay, _t])
	
func _physics_process(delta: float) -> void:
	if _t_delay < delay_time_seconds:
		_t_delay += delta
	else:
		_t += delta
		
	if not _projectile:
		_add_fire_projectile()

	_projectile.set_charge(_t / cycle_time_seconds)
	totem_sprite.frame = int(floor((_t / cycle_time_seconds) * (FRAME_COUNT - 1)))
	if _t >= cycle_time_seconds:
		_fire()
		_t = 0.0
		
		
func _fire() -> FireProjectile:
	if not _projectile: return
	_projectile.fire(fire_vector)
	var just_fired = _projectile
	_projectile = null
	return just_fired
	
