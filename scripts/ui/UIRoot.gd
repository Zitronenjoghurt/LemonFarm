extends CanvasLayer

@onready var player: Player = %Player
@onready var inventory_dialog: InventoryDialog = %InventoryDialog
@onready var pause_dialog: PauseDialog = %PauseDialog

func _ready():
	pass

func _unhandled_input(event):
	if event.is_action_released("Inventory"):
		if inventory_dialog.visible:
			inventory_dialog.close()
		else:
			inventory_dialog.open(player.inventory)
	
	if event.is_action_released("Pause"):
		if pause_dialog.visible:
			pause_dialog.close()
		else:
			pause_dialog.open()
	
