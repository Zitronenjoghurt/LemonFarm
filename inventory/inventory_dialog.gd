class_name InventoryDialog
extends PanelContainer

@export var slot_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer

func _on_close_button_pressed():
	close()

func open(inventory: Inventory):
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for item_id in inventory.get_items():
		var slot = slot_scene.instantiate()
		grid_container.add_child(slot)
		
		var item = inventory.get_item_by_id(item_id)
		var amount = inventory.get_amount(item_id)
		slot.display_item(item, amount)

func close():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
