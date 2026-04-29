class_name AmbushSpider
extends Enemy

signal died

func play_animation(animation_name: String) -> void:
	$AnimatedSprite2D.play(animation_name)
	
func emit_blood_particles() -> void:
	$BloodParticles.restart()
	
func die() -> void:
	died.emit()
