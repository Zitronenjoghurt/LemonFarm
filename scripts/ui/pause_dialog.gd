extends PanelContainer
class_name PauseDialog

func open():
	show()
	Global.paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close():
	hide()
	Global.paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_continue_button_pressed():
	close()

func _on_exit_button_pressed():
	await SaveManager.save_game(0)
	get_tree().quit()
