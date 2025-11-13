extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Level.set_active_spawn_point(get_parent() as SpawnPoint)
