class_name TurretTrapProjectile
extends CharacterBody2D

const ROTATIONS_PER_SECOND := 1.0
const MAX_LIFE_SECONDS := 5.0

@export var explosion_scene: PackedScene

var charge: float

var _fired_collision_layer
var _fired_collision_mask
var _projectile_velocity := Vector2(0.0, 0.0)
var _fired := false
var _time_since_fired := 0.0

var bullet: Sprite2D:
	get: return $BulletTemp

func fire(vel: Vector2) -> void:
	_fired = true
	_projectile_velocity = vel
	collision_layer = _fired_collision_layer
	collision_mask = _fired_collision_mask

func _ready() -> void:
	bullet.material = bullet.material.duplicate()
	_fired_collision_layer = collision_layer
	_fired_collision_mask = collision_mask
	collision_layer = 0
	collision_mask = 0

func _physics_process(delta: float) -> void:
	if _fired:
		_time_since_fired += delta
	velocity = _projectile_velocity
	rotate(TAU * ROTATIONS_PER_SECOND * delta)
	move_and_slide()

	if _fired:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("Player"):
				_hit_player()
			elif collider.is_in_group("Gnome"):
				_hit_gnome(collider as Gnome)
			else:
				die()
	if _time_since_fired >= MAX_LIFE_SECONDS:
		die()

	bullet.material.set_shader_parameter("charge", charge)

func player_collided_with_projectile() -> void:
	if _fired: _hit_player()

func gnome_collided_with_projectile(gnome: Gnome) -> void:
	if _fired: _hit_gnome(gnome)

func _hit_player() -> void:
	Events.player_hit_projectile_sync()
	die()

func _hit_gnome(gnome: Gnome) -> void:
	Events.gnome_hit_projectile_sync(gnome)
	die()


func die() -> void:
	var explosion = explosion_scene.instantiate() as TurretTrapProjectileExplosion
	explosion.position = position
	get_parent().add_child(explosion)
	explosion.explode()
	queue_free()
