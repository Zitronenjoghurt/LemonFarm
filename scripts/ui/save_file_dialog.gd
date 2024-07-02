class_name SaveFileDialog
extends PanelContainer

@export var file_item_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer

const save_file_count: int = 4

func open():
	show()
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for i in range(save_file_count):
		var file_scene = file_item_scene.instantiate()
		grid_container.add_child(file_scene)
		file_scene.display_save_file(i, SaveManager.save_file_exists(i))
