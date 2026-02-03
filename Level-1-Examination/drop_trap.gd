class_name DropTrap
extends Node2D

@export var cycle_envelope: ADLoop
@export var hit_sounds: Array[AudioStreamWAV] = []

var _path_follow: PathFollow2D:
	get: return $Path2D/PathFollow2D

var _trap_body: AnimatableBody2D:
	get: return $TrapBody

var _hit_player: AudioStreamPlayer2D:
	get: return $HitPlayer

var _hit_particles: GPUParticles2D:
	get: return $TrapBody/HitParticles

@onready var _hit_effect_player := EffectPlayer.new(_hit_player, hit_sounds, {EffectPlayer.MIN_VOLUME: 0.0, EffectPlayer.MAX_VOLUME: 3.0})

func _ready() -> void:
	assert(cycle_envelope != null, 'A value must be assigned to the cycle envelope')
	cycle_envelope.ready()
	cycle_envelope.phase_changed.connect(_on_cycle_envelope_phase_changed)

func _physics_process(delta: float) -> void:
	cycle_envelope.physics_update(delta)
	_path_follow.progress_ratio = cycle_envelope.sample()
	var movement = _path_follow.position - _trap_body.position
	var collision = _trap_body.move_and_collide(movement)
	#force movement to the correct position, now that we have collisions
	_trap_body.position = _path_follow.position

	# exit if we are moving up. We only care about collisions with player/gnomes when falling
	if movement.y <= 0.0: 
		return

	if collision:
		var collider = collision.get_collider()
		var did_hit_top = is_equal_approx(collision.get_normal().angle_to(Vector2.UP), 0.0)
		if collider.is_in_group("Player") and did_hit_top:
			Events.player_hit_drop_trap_async(self)
		elif collider.is_in_group("Gnome") and did_hit_top:
			Events.gnome_hit_drop_trap_async(self, collider as Gnome)
		
func _on_cycle_envelope_phase_changed(phase: ADLoop.Phase) -> void:
	if phase == ADLoop.Phase.DECAY:
		_hit_effect_player.play()
		_hit_particles.restart()
	else:
		_hit_particles.emitting = false
