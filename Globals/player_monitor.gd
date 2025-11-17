class_name PlayerMonitor
extends Node

var _player: Player

var player: Player:
	set(value): _player = value
	get: return _player

func distance_to(point: Vector2) -> float:
	return _player.position.distance_to(point)
