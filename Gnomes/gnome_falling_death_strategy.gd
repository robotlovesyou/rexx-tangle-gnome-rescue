class_name GnomeFallingDeathStrategy
extends GnomeStrategy

var _gnome: Gnome

func _init(gnome: Gnome):
	_gnome = gnome

func state_id() -> StateID:
	return StateID.FALLING_DEATH
	
func on_physics_process(delta: float) -> void:
	_gnome.velocity += _gnome.get_gravity() * delta
	_gnome.move_and_slide()
	if _gnome.is_on_floor():
		Events.gnome_hit_floor_fatally_async(_gnome)
	
func on_animate(sprite: AnimatedSprite2D) -> void:
	sprite.play("jump")
