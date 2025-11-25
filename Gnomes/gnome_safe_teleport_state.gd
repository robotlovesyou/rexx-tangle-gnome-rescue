class_name GnomeSafeTeleportState
extends GnomeState

func state_id() -> StateID: return StateID.SAFE_TELEPORTING

const PARTICLES_START_Y := 16.0
const PARTICLES_END_Y := -16.0
const TIME_IN_STATE_SECONDS := 2.0
const TIME_GNOME_VISIBLE_SECONDS := 1.0

var _gnome: Gnome
var _t := 0.0

func _init(gnome: Gnome):
	_gnome = gnome

func on_enter_state() -> void:
	_gnome.safe_teleport_particles.position.y = PARTICLES_START_Y
	_gnome.safe_teleport_particles.emitting = true

func on_physics_process(delta: float) -> void:
	_t += delta

	_gnome.safe_teleport_particles.position.y = lerp(PARTICLES_START_Y, PARTICLES_END_Y, _t / TIME_GNOME_VISIBLE_SECONDS)

	if _t > TIME_GNOME_VISIBLE_SECONDS:
		_gnome.animated_sprite.visible = false
		_gnome.safe_teleport_particles.emitting = false

	if _t > TIME_IN_STATE_SECONDS:
		_gnome.queue_free()


func on_animate(sprite: AnimatedSprite2D) -> void:
	sprite.play("disappear")
	

