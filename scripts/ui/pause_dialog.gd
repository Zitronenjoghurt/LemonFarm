extends PanelContainer
class_name PauseDialog

func open():
	show()
	Global.paused = true
	Global.player_can_move = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close():
	hide()
	Global.paused = false
	Global.player_can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_continue_button_pressed():
	close()

func _on_exit_button_pressed():
	await SaveManager.save_game(0)
	get_tree().quit()

func _on_main_menu_button_pressed():
	Global.player_can_move = true
	await SaveManager.save_game(0)
	var main_menu = load(Global.main_menu_scene_path)
	main_menu.instantiate()
	get_tree().call_deferred("change_scene_to_packed", main_menu)
	
