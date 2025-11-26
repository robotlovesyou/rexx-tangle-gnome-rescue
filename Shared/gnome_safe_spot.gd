class_name GnomeSafeSpot
extends Node2D

var center_x: float:
	get: return position.x + ($Sprite2D.texture.get_size().x / 2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Gnome: return
	(body as Gnome).hit_safe_spot(self)
