class_name MainMenuDialog
extends PanelContainer

func _on_continue_button_pressed():
	SaveManager.load_game(0)

func _on_exit_button_pressed():
	get_tree().quit()
