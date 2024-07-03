extends PanelContainer
class_name PauseDialog

func open():
	show()
	Global.paused = true
	Global.player_move_blocked.subscribe(Global.PlayerMoveBlocked.PAUSE)
	MouseManager.visible(MouseManager.VisibilitySource.PAUSE)

func close():
	hide()
	Global.paused = false
	Global.player_move_blocked.unsubscribe(Global.PlayerMoveBlocked.PAUSE)
	MouseManager.hidden(MouseManager.VisibilitySource.PAUSE)

func _on_continue_button_pressed():
	close()

func _on_exit_button_pressed():
	await SaveManager.save_game()
	get_tree().quit()

func _on_main_menu_button_pressed():
	close()
	await SaveManager.save_game()
	var main_menu = load(Global.main_menu_scene_path)
	DayNightModulate.deactivate()
	main_menu.instantiate()
	get_tree().call_deferred("change_scene_to_packed", main_menu)
	MouseManager.visible(MouseManager.VisibilitySource.MAIN_MENU)
	
