extends Node

var inventories: Dictionary = {}

# The item currently in the hand of the cursor
var _item: Item = null
var _item_amount: int = 0
var _item_inventory_id: String = ""
var _current_item_scene: ItemInHand = null
const hand_item_scene_path = "res://scenes/ui/item_in_hand.tscn"

signal inventory_closed

enum PickUpMode {
	FULL,
	HALF,
	ONE
}

enum PutDownMode {
	FULL,
	ONE
}

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
	Global.player_move_blocked.subscribe(Global.PlayerMoveBlocked.INVENTORY)
	ui_root.open_secondary_inventory(inventory, inventory_name, inventory_id)

func _on_inventory_slot_clicked(id: String, index: int, click_type: Enums.MouseClickType):
	if id not in inventories:
		return
		
	var redraw = false
	match click_type:
		Enums.MouseClickType.LEFT_CLICK:
			if _item is Item:
				redraw = put_down_item(id, index, PutDownMode.FULL)
			else:	
				redraw = pick_up_item(id, index, PickUpMode.FULL)
		Enums.MouseClickType.SHIFT_LEFT_CLICK:
			redraw = shift_click(id, index)
		Enums.MouseClickType.RIGHT_CLICK:
			if _item is Item:
				var target_dialog = inventories[id] as InventoryDialog
				var target_item = target_dialog.inventory.get_item_at_slot(index)
				if _item == target_item:
					redraw = pick_up_item(id, index, PickUpMode.ONE)
				else:
					redraw = put_down_item(id, index, PutDownMode.ONE)
			else:
				redraw = pick_up_item(id, index, PickUpMode.ONE)
		Enums.MouseClickType.SHIFT_RIGHT_CLICK:
			redraw = pick_up_item(id, index, PickUpMode.HALF)
	
	if redraw == true:
		redraw_inventories()

func pick_up_item(source_id: String, source_index: int, mode: PickUpMode) -> bool:
	if source_id not in inventories:
		return false
		
	var source_dialog = inventories[source_id] as InventoryDialog
	var item = source_dialog.inventory.get_item_at_slot(source_index)
	if item == null:
		return false
	
	var full_amount = source_dialog.inventory.get_amount_at_slot(source_index)
	var pick_amount = 1
	match mode:
		PickUpMode.FULL:
			pick_amount = full_amount
		PickUpMode.HALF:
			pick_amount = max(1, int(full_amount/2))
			
	if _item == item and mode == PickUpMode.ONE:
		_item_amount += 1
		_current_item_scene.update_amount(_item_amount)
	elif _item == item and mode == PickUpMode.HALF:
		_item_amount += pick_amount
		_current_item_scene.update_amount(_item_amount)
	else:
		var item_in_hand_scene = load(hand_item_scene_path)
		var item_scene = item_in_hand_scene.instantiate() as ItemInHand
		item_scene.display(item, pick_amount)
		
		var ui_root = get_tree().get_first_node_in_group("ui_root")
		ui_root.add_child(item_scene)
		
		_item = item
		_item_amount = pick_amount
		_item_inventory_id = source_id
		_current_item_scene = item_scene
	
	if pick_amount == full_amount:
		source_dialog.inventory.clear_slot(source_index)
	else:
		source_dialog.inventory.remove_item_at_slot(source_index, pick_amount)
	
	return true
	
func put_down_item(target_id: String, target_index: int, mode: PutDownMode) -> bool:
	if target_id not in inventories:
		return false

	var item = _item
	var amount = _item_amount
	
	if amount == 1:
		mode = PutDownMode.FULL
	
	var target_dialog = inventories[target_id] as InventoryDialog
	var item_at_target = target_dialog.inventory.get_item_at_slot(target_index)
	
	var target_item_is_different_item = item_at_target is Item and item != item_at_target
	
	# The order is very important here, thats why this is checked twice
	if target_item_is_different_item:
		mode = PutDownMode.FULL
	
	if mode == PutDownMode.FULL:
		clear_hand_item()
	else:
		amount = 1
		_item_amount -= 1
		_current_item_scene.update_amount(_item_amount)
	
	if target_item_is_different_item:
		pick_up_item(target_id, target_index, PickUpMode.FULL)
	
	target_dialog.inventory.add_item(item, amount, target_index)
	return true
			
func shift_click(source_id: String, source_index: int) -> bool:
	if source_id not in inventories:
		return false
	
	var target_id = get_other_target(source_id)
	if target_id == null:
		target_id = source_id
	
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

func clear_hand_item():
	_item = null
	_item_inventory_id = ""
	_item_amount = 0
	_current_item_scene.queue_free()
	_current_item_scene = null

func on_inventory_closed():
	# Restore item back to previous inventory if its still in hand
	if _item is Item and _item_inventory_id in inventories:
		var dialog = inventories[_item_inventory_id] as InventoryDialog
		dialog.inventory.add_item(_item, _item_amount)
		clear_hand_item()
		
	Global.player_move_blocked.unsubscribe(Global.PlayerMoveBlocked.INVENTORY)
	var inventory_ids = inventories.keys()
	for inventory_id in inventory_ids:
		inventories[inventory_id].close()
		unregister(inventory_id)
	inventory_closed.emit()
