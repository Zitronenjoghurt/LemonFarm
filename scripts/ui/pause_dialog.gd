extends PanelContainer
class_name PauseDialog

func open():
	show()

func close():
	hide()

func _on_continue_button_pressed():
	close()

func _on_exit_button_pressed():
	await SaveManager.save_game(0)
	get_tree().quit()
