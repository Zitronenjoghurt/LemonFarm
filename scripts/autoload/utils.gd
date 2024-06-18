extends Node

func is_direction_key_pressed() -> bool:
	return Input.is_action_pressed("Up") or Input.is_action_pressed("Down") or Input.is_action_pressed("Left") or Input.is_action_pressed("Right")
