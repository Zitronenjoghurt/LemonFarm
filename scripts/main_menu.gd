extends Node2D

@onready var main_menu_dialog: MainMenuDialog = %MainMenuDialog
@onready var save_file_dialog: SaveFileDialog = %SaveFileDialog

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		menu_back()

func menu_back():
	if save_file_dialog.visible:
		save_file_dialog.hide()
		main_menu_dialog.show()
