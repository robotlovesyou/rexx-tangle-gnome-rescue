class_name AmbushSpiderRoot
extends Node2D

const SPEED := 400.0
const ACCELERATION = 1500.0

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
			
func _physics_process(delta: float) -> void:
	var gravity := ambush_spider.get_gravity()
	ambush_spider.velocity.y = gravity.y
	if _player_detected:
		ambush_spider.play_animation("walk")
		var direction := signf(to_local(PMonitor.player.global_position).x - ambush_spider.position.x)
		ambush_spider.velocity.x = move_toward(ambush_spider.velocity.x, direction * SPEED, delta * ACCELERATION)
	else:
		ambush_spider.velocity.x = 0.0
		ambush_spider.play_animation("idle")
		
	ambush_spider.move_and_slide()
