class_name TurretTrapProjectile
extends CharacterBody2D

const ROTATIONS_PER_SECOND := 1.0
const MAX_LIFE_SECONDS := 5.0

@export var explosion_scene: PackedScene

var projectile_velocity := Vector2(0.0, 0.0)

var _time_alive := 0.0

func _physics_process(delta: float) -> void:
	_time_alive += delta
	velocity = projectile_velocity
	rotate(TAU * ROTATIONS_PER_SECOND * delta)
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Player"):
			_hit_player()
		elif collider.is_in_group("Gnome"):
			_hit_gnome(collider as Gnome)
		else:
			die()
	if _time_alive >= MAX_LIFE_SECONDS:
		die()

func player_collided_with_projectile() -> void:
	_hit_player()

func gnome_collided_with_projectile(gnome: Gnome) -> void:
	_hit_gnome(gnome)

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
