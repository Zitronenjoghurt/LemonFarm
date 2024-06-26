extends Node

var inventories: Dictionary = {}

# The item currently in the hand of the cursor
var item: Item = null
var item_amount: int = 0

signal inventory_closed

func register(dialog: InventoryDialog, id: String):
	inventories[id] = dialog
	dialog.inventory_slot_clicked.connect(_on_inventory_slot_clicked)
	dialog.inventory_closed.connect(on_inventory_closed)

func unregister(id: String):
	if id not in inventories:
		return
	if inventories[id].inventory_slot_clicked.is_connected(_on_inventory_slot_clicked):
		inventories[id].inventory_slot_clicked.disconnect(_on_inventory_slot_clicked)
	if inventories[id].inventory_closed.is_connected(on_inventory_closed):
		inventories[id].inventory_closed.disconnect(on_inventory_closed)
	inventories.erase(id)

func redraw_inventories():
	for id in inventories:
		inventories[id].draw()

func get_other_target(source_id: String):
	if len(inventories) < 2:
		return null
	
	var keys = inventories.keys()
	keys.erase(source_id)
	
	return keys[0]
	
func open_secondary_inventory(inventory: Inventory, inventory_name: String, inventory_id: String):
	var ui_root: UIRoot = get_tree().get_first_node_in_group("ui_root")
	if not ui_root is UIRoot:
		return
	Global.player_can_move = false
	ui_root.open_secondary_inventory(inventory, inventory_name, inventory_id)

func _on_inventory_slot_clicked(id: String, index: int, click_type: Enums.MouseClickType):
	if id not in inventories:
		return
		
	var redraw = false
	match click_type:
		Enums.MouseClickType.SHIFT_LEFT_CLICK:
			redraw = shift_click(id, index)
	
	if redraw == true:
		redraw_inventories()
			
func shift_click(source_id: String, source_index: int) -> bool:
	var target_id = get_other_target(source_id)
	if target_id == null:
		return false
	
	var source_dialog = inventories[source_id] as InventoryDialog
	var item = source_dialog.inventory.get_item_at_slot(source_index)
	if item == null:
		return false
	
	var amount = source_dialog.inventory.get_amount_at_slot(source_index)
	
	var target_dialog = inventories[target_id] as InventoryDialog
	var success = target_dialog.inventory.add_item(item, amount)
	if success == false:
		return false
	
	source_dialog.inventory.remove_item_at_slot(source_index, amount)
	return true
	
func on_inventory_closed():
	Global.player_can_move = true
	var inventory_ids = inventories.keys()
	for inventory_id in inventory_ids:
		inventories[inventory_id].close()
		unregister(inventory_id)
	inventory_closed.emit()
