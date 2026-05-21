class_name DropTrapWood
extends Node2D

@export var attack := 1.0
@export var decay := 1.0
@export var time_offset := 0.0
@export var hit_sounds: Array[AudioStreamWAV] = []
var _cycle_envelope: ADLoop
var _path_follow: PathFollow2D:
	get: return $Path2D/PathFollow2D

var _trap_body: AnimatableBody2D:
	get: return $TrapBody

var _hit_player: AudioStreamPlayer2D:
	get: return $HitPlayer

var _hit_particles: GPUParticles2D:
	get: return $TrapBody/HitParticles
	
var _shape_cast: ShapeCast2D:
	get: return $TrapBody/ShapeCast2D

@onready var _hit_effect_player := EffectPlayer.new(_hit_player, hit_sounds, {EffectPlayer.MIN_VOLUME: 0.0, EffectPlayer.MAX_VOLUME: 3.0})

func _ready() -> void:
	_cycle_envelope = ADLoop.new()
	_cycle_envelope.attack = attack
	_cycle_envelope.decay = decay
	_cycle_envelope.time_offset = time_offset
	_cycle_envelope.ready()
	_cycle_envelope.phase_changed.connect(_on_cycle_envelope_phase_changed)
	_hit_particles.lifetime = decay

func _physics_process(delta: float) -> void:
	_cycle_envelope.physics_update(delta)
	_path_follow.progress_ratio = _cycle_envelope.sample()
	var movement = _path_follow.position - _trap_body.position
	_cast_for_collisions(movement)
	_trap_body.move_and_collide(movement)
	_trap_body.position = _path_follow.position # force to the correct position even if there were collisions
			
func _cast_for_collisions(movement: Vector2) -> void:
	if movement.y <= 0.0: return # no collision checks when moving upward
	_shape_cast.target_position = movement
	_shape_cast.force_shapecast_update()
	for i in range(_shape_cast.get_collision_count()):
		var collider = _shape_cast.get_collider(i)
		var normal = _shape_cast.get_collision_normal(i)
		var did_hit_top = is_equal_approx(normal.angle_to(Vector2.UP), 0.0)
		if collider.is_in_group("Player") and did_hit_top:
			Events.player_hit_drop_trap_async(null)
		elif collider.is_in_group("Gnome") and did_hit_top:
			Events.gnome_hit_drop_trap_async(null, collider as Gnome)
		
func _on_cycle_envelope_phase_changed(phase: ADLoop.Phase) -> void:
	if phase == ADLoop.Phase.DECAY:
		_hit_effect_player.play()
		_hit_particles.restart()
	else:
		_hit_particles.emitting = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("entered")
