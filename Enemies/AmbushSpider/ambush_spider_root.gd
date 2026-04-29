class_name AmbushSpiderRoot
extends Node2D

const SPEED := 400.0
const ACCELERATION = 1500.0
const TIME_DEAD_SECONDS := 3.0

@export var steps: Array[AudioStreamWAV]
@export var death_sounds: Array[AudioStreamWAV]

var _walk_effect_player: WalkEffectPlayer
var _death_effect_player: EffectPlayer

var _state: Enemy.State
var _time_dead := 0.0

var walk_player: AudioStreamPlayer2D:
	get: return $AmbushSpider/WalkPlayer
	
var death_player: AudioStreamPlayer2D:
	get: return $AmbushSpider/DeathPlayer

var ambush_spider: AmbushSpider:
	get: return $AmbushSpider
	
var detection_area: Area2D:
	get: return $DetectionArea
	
var _player_detected := false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is not Player: return
	_player_detected = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is not Player: return
	_player_detected = false
	
func _initialize_player_detected() -> void:
	for body in detection_area.get_overlapping_bodies():
		if body is Player:
			_player_detected = true
			break
			
func _ready() -> void:
	_walk_effect_player = WalkEffectPlayer.new(walk_player,steps)
	_death_effect_player = EffectPlayer.new(death_player, death_sounds)
	_state = Enemy.State.ALIVE
			
func _physics_process(delta: float) -> void:
	var gravity := ambush_spider.get_gravity()
	ambush_spider.velocity += gravity
	match _state:
		Enemy.State.ALIVE:
			if _player_detected:
				ambush_spider.play_animation("walk")
				_walk_effect_player.play()
				var direction := signf(to_local(PMonitor.player.global_position).x - ambush_spider.position.x)
				ambush_spider.velocity.x = move_toward(ambush_spider.velocity.x, direction * SPEED, delta * ACCELERATION)
			else:
				ambush_spider.velocity.x = 0.0
				ambush_spider.play_animation("idle")
				_walk_effect_player.stop()
		Enemy.State.DEAD:
			_time_dead += delta
			if _time_dead >= TIME_DEAD_SECONDS:
				queue_free()
		
	ambush_spider.move_and_slide()


func _on_ambush_spider_died() -> void:
	if _state == Enemy.State.DEAD: return
	_state = Enemy.State.DEAD
	_walk_effect_player.stop()
	_death_effect_player.play()
	ambush_spider.emit_blood_particles()
	ambush_spider.set_collision_layer_value(5, false)
	ambush_spider.set_collision_mask_value(1, false)
	ambush_spider.set_collision_mask_value(2, false)
	ambush_spider.play_animation("squish")
