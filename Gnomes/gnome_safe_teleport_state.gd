class_name GnomeSafeTeleportState
extends GnomeState

enum Phase {LEAP_ALIGN, LAND, TELEPORT}

func state_id() -> StateID: return StateID.SAFE_TELEPORTING

const PARTICLES_START_Y := 16.0
const PARTICLES_END_Y := -16.0
const TIME_IN_STATE_SECONDS := 2.0
const TIME_GNOME_VISIBLE_SECONDS := 1.0

var _gnome: Gnome
var _t := 0.0
var _t_apex := 0.0
var _phase := Phase.LEAP_ALIGN
var _jump_velocity := 0.0


func _init(gnome: Gnome):
	_gnome = gnome
	_jump_velocity = _gnome.movement_config.JUMP_VELOCITY

func on_enter_state() -> void:
	_gnome.safe_teleport_particles.position.y = PARTICLES_START_Y
	_t_apex = abs(_jump_velocity) / _gnome.get_gravity().y
	_gnome.velocity.y = _jump_velocity
	_gnome.velocity.x = (_gnome.safe_spot.center_x - _gnome.position.x) / _t_apex / 2.0
	FollowersMonitor.remove(_gnome)


func on_physics_process(delta: float) -> void:
	_t += delta

	match _phase:
		Phase.LEAP_ALIGN:
			if _t >= _t_apex:
				_phase = Phase.LAND
		Phase.LAND:
			if _t >= 2.0 * _t_apex:
				_gnome.move_behind_safe_spot()
				_gnome.safe_teleport_particles.emitting = true
				_gnome.velocity.x = 0.0
				_phase = Phase.TELEPORT
		Phase.TELEPORT:
			_gnome.safe_teleport_particles.position.y = lerp(PARTICLES_START_Y, PARTICLES_END_Y, _t / TIME_GNOME_VISIBLE_SECONDS)

			if _t > TIME_GNOME_VISIBLE_SECONDS + _t_apex * 2.0:
				_gnome.animated_sprite.visible = false
				_gnome.safe_teleport_particles.emitting = false

			if _t > TIME_IN_STATE_SECONDS + _t_apex * 2.0:
				_gnome.queue_free()

	_gnome.velocity.y += _gnome.get_gravity().y * delta
	_gnome.move_and_slide()


func on_animate(sprite: AnimatedSprite2D) -> void:
	if _phase == Phase.TELEPORT:
		sprite.play("disappear")
	

