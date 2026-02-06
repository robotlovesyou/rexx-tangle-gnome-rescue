class_name TurretTrapProjectile
extends CharacterBody2D

var projectile_velocity := Vector2(0.0, 0.0)

func _physics_process(_delta: float) -> void:
	velocity = projectile_velocity
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

func player_collided_with_projectile() -> void:
	_hit_player()
	die()

func gnome_collided_with_projectile(gnome: Gnome) -> void:
	_hit_gnome(gnome)
	die()

func _hit_player() -> void:
	Events.player_hit_projectile_sync()

func _hit_gnome(gnome: Gnome) -> void:
	Events.gnome_hit_projectile_sync(gnome)


func die() -> void:
	queue_free()
