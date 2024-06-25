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
	
	for i in range (inventory.get_slot_count()):
		var slot = slot_scene.instantiate()
		grid_container.add_child(slot)
		
		var item = inventory.get_item_at_slot(i)
		if item is Item:
			var amount = inventory.get_amount_at_slot(i)
			slot.display_item(item, amount)

func close():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
