class_name InstructionDialog
extends CenterContainer

func expand() -> void:
	$ExpandAndContract.play("expand")

func contract() -> void:
	$ExpandAndContract.play("contract")



func _on_activation_body_exited(body: Node2D) -> void:
	if body is Player:
		contract()

func _on_activation_body_entered(body: Node2D) -> void:
	if body is Player:
		expand()
