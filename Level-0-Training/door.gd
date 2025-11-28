class_name Door
extends Node2D

enum Phase {CLOSED, OPENING, OPEN}

var _phase := Phase.CLOSED

var _door_collision_shape: CollisionShape2D:
	get: return $DoorCollider/CollisionShape2D

var _door_animation: AnimatedSprite2D:
	get: return $DoorAnimation

var _door_sound: AudioStreamPlayer2D:
	get: return $DoorSound


func open_door() -> void: 
	_phase = Phase.OPENING
	_door_animation.play("opening")
	_door_sound.play()


func _on_door_animation_animation_finished() -> void:
	if _phase == Phase.OPENING:
		_phase = Phase.OPEN
		_door_collision_shape.disabled = true
