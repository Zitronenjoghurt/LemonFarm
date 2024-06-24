extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var inventory_dialog: InventoryDialog = %InventoryDialog
@onready var pause_dialog: PauseDialog = %PauseDialog

func _ready():
	pass

func _unhandled_input(event):
	if Global.in_dialogue:
		return
	
	if event.is_action_released("Inventory") and not Global.paused:
		if inventory_dialog.visible:
			inventory_dialog.close()
		else:
			inventory_dialog.open(player.inventory)
	
	if event.is_action_released("Pause"):
		if pause_dialog.visible:
			pause_dialog.close()
		else:
			pause_dialog.open()
			inventory_dialog.hide()
