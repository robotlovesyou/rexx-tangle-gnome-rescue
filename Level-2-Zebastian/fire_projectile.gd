class_name FireProjectile
extends CharacterBody2D

const FRAME_COUNT := 4.0
const FINAL_ENERGY := 1.0
var charge_time_seconds := 2.0
var life_time_seconds := 10.0
var _t := 0.0

var projectile_sprite: Sprite2D:
	get: return $ProjectileSprite
	
var projectile_light: PointLight2D:
	get: return $ProjectileLight
	
func _ready() -> void:
	velocity = Vector2.ZERO
	create_tween()\
		.tween_property(projectile_light, "energy", FINAL_ENERGY, charge_time_seconds)

func _physics_process(delta: float) -> void:
	_t += delta
	if _t <= charge_time_seconds:
		projectile_sprite.frame = int(floor((_t / charge_time_seconds) * FRAME_COUNT))
		
	projectile_sprite.rotate(PI * delta)
	
	move_and_slide()
	
	if _t >= life_time_seconds:
		queue_free()
	
func fire(v: Vector2) -> void:
	velocity = v
	
func _on_collision_area_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.player_burned_async()
	elif body is Gnome:
		Events.gnome_burned_async(body as Gnome)
