class_name SaveFileItem
extends PanelContainer

@onready var label: Label = %Label
@onready var play_button: Button = %PlayButton
@onready var new_button: Button = %NewButton
@onready var delete_button: Button = %DeleteButton

var file_index = -1

func display_save_file(index: int, exists: bool):
	label.text = "File " + str(index + 1)
	file_index = index
	
	if not exists:
		play_button.hide()
		new_button.show()
		delete_button.hide()
	else:
		play_button.show()
		new_button.hide()
		delete_button.show()
		
func _on_play_button_pressed():
	start()

func _on_new_button_pressed():
	start()
	
func _on_delete_button_pressed():
	SaveManager.delete_game(file_index)
	SaveManager.delete_game(file_index)
	display_save_file(file_index, false)

func start():
	if file_index < 0:
		return
	Global.current_save_file = file_index
	SaveManager.load_game(file_index)
	MouseManager.hidden(MouseManager.VisibilitySource.MAIN_MENU)
