class_name UIRoot
extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var inventory_dialog1: InventoryDialog = %InventoryDialog1
@onready var inventory_dialog2: InventoryDialog = %InventoryDialog2
@onready var pause_dialog: PauseDialog = %PauseDialog

func _ready():
	add_to_group("ui_root")

func _unhandled_input(event):
	if Global.in_dialogue:
		return
	
	if event.is_action_released("Inventory") and not Global.paused:
		if inventory_dialog1.visible:
			InventoryManager.on_inventory_closed()
		else:
			open_player_inventory()
	
	if event.is_action_released("Pause"):
		if pause_dialog.visible:
			pause_dialog.close()
		else:
			InventoryManager.on_inventory_closed()
			pause_dialog.open()
			
func open_player_inventory():
	inventory_dialog1.open(player.inventory, "Inventory", "player")
	inventory_dialog1.horizontal_mode()

func open_secondary_inventory(inventory: Inventory, inventory_name: String, inventory_id: String):
	open_player_inventory()
	inventory_dialog2.open(inventory, inventory_name, inventory_id)
	inventory_dialog1.vertical_mode()
	inventory_dialog2.vertical_mode()
