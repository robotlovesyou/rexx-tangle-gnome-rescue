class_name PoisonedRexx
extends DyingRexx

var poisoned_body: AnimatableBody2D:
	get: return $PoisonedBody
	
var animated_sprite: AnimatedSprite2D:
	get: return $PoisonedBody/AnimatedSprite2D
	
var flip_h := false
	
func _physics_process(delta: float) -> void:
	super(delta)
	poisoned_body.velocity += poisoned_body.get_gravity()
	poisoned_body.move_and_slide()
	animated_sprite.flip_h = flip_h
	
