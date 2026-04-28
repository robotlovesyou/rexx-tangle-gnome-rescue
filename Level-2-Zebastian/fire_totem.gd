class_name FireTotem
extends Node2D

const FRAME_COUNT = 4.0
var _t := 0.0
var _projectile: FireProjectile = null

var totem_sprite: Sprite2D:
	get: return $TotemSprite

var projectile_anchor: Node2D:
	get: return $ProjectileAnchor

@export var cycle_time_seconds = 2.0
@export var projectile_scene: PackedScene

func _add_fire_projectile() -> void:
	_projectile = projectile_scene.instantiate() as FireProjectile
	_projectile.charge_time_seconds = cycle_time_seconds
	add_child(_projectile)
	_projectile.position = projectile_anchor.position
	

func _physics_process(delta: float) -> void:
	if not _projectile:
		_add_fire_projectile()
	_t += delta
	totem_sprite.frame = int(floor((_t / cycle_time_seconds) * (FRAME_COUNT - 1)))
	if _t >= cycle_time_seconds:
		_fire()
		_t = 0.0
		
		
func _fire() -> void:
	if not _projectile: return
	_projectile.fire(Vector2(-100.0, 0.0))
	_projectile = null
	
