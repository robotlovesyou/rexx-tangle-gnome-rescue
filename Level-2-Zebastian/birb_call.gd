class_name BirbCall
extends Node2D

@export var birb_swarm: BirbSwarm

var button: AnimatedSprite2D:
	get: return $BirbFeeder/Button
	
var button_click_on: AudioStreamPlayer2D:
	get: return $BirbFeeder/ButtonClickOn
	
var button_click_off: AudioStreamPlayer2D:
	get: return $BirbFeeder/ButtonClickOff
	
var seed_pour: AudioStreamPlayer2D:
	get: return $BirbFeeder/SeedPour
	
var seed_dispenser_particles: GPUParticles2D:
	get: return $BirbFeeder/SeedDispenserParticles
	
var seedz: AnimatedSprite2D:
	get: return $BirbFeeder/Seedz
	
func _on_button_activation_body_entered(body: Node2D) -> void:
	if body is not Player: return
	var player = body as Player
	button.play("press")
	button_click_on.play()
	birb_swarm.start()
	seed_dispenser_particles.global_position.x = player.global_position.x
	seed_dispenser_particles.restart()
	seedz.show()
	seedz.play("pile")
	seedz.global_position.x = player.global_position.x

func _on_button_activation_body_exited(body: Node2D) -> void:
	if body is not Player: return
	button.play("release")
	button_click_off.play()
	seedz.hide()


func _on_button_click_on_finished() -> void:
	seed_pour.play()
