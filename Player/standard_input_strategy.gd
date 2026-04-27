class_name StandardInputStrategy
extends InputStrategy

func get_h_axis() -> float:
	return Input.get_axis("ui_left", "ui_right")
	
func just_pressed_jump() -> bool:
	return Input.is_action_just_pressed("ui_accept")
	
func just_released_jump() -> bool:
	return Input.is_action_just_released("ui_accept")
