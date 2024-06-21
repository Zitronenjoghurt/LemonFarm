extends CanvasLayer

@onready var player: Player = %Player
@onready var inventory_dialog: InventoryDialog = %InventoryDialog

func _unhandled_input(event):
	if event.is_action_released("Inventory"):
		if inventory_dialog.visible:
			inventory_dialog.close()
		else:
			inventory_dialog.open(player.inventory)
