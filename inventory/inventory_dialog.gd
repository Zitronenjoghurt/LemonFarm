class_name InventoryDialog
extends PanelContainer

@export var slot_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer
@onready var title_label: Label = %TitleLabel

signal inventory_slot_clicked(id: String, index: int)
signal inventory_closed()

var inventory: Inventory = Inventory.new()
var _inventory_id: String = "inventory"

func _on_close_button_pressed():
	inventory_closed.emit()

func draw():
	for child in grid_container.get_children():
		child.queue_free()
	
	for i in range (inventory.get_slot_count()):
		var slot = slot_scene.instantiate() as InventoryItemSlot
		slot.set_index(i)
		slot.slot_clicked.connect(_on_slot_clicked)
		grid_container.add_child(slot)
		
		var item = inventory.get_item_at_slot(i)
		if item is Item:
			var amount = inventory.get_amount_at_slot(i)
			slot.display_item(item, amount)
		else:
			slot.clear()

func open(source_inventory: Inventory, title: String = "Inventory", inventory_id: String = "inventory"):
	inventory = source_inventory
	_inventory_id = inventory_id
	
	InventoryManager.register(self, inventory_id)
	
	title_label.text = title
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	draw()
	show()
	
func close():
	inventory = Inventory.new()
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_slot_clicked(index: int, click_type: Enums.MouseClickType):
	inventory_slot_clicked.emit(_inventory_id, index, click_type)
