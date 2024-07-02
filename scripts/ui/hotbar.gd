class_name HotBar
extends PanelContainer

@export var slot_count: int = 9
@export var item_slot_scene: PackedScene
@onready var grid_container: GridContainer = %GridContainer

var selected_slot: int = 0
var slot_scenes: Array[HotBarItemSlot] = []

func _ready():
	grid_container.columns = slot_count
	
	for i in range(slot_count):
		var scene = item_slot_scene.instantiate()
		grid_container.add_child(scene)
		slot_scenes.append(scene)
		if i == 0:
			scene.select()

func update_items(inventory: Inventory):
	for i in range(slot_count):
		var item = inventory.get_item_at_slot(i)
		var amount = inventory.get_amount_at_slot(i)
		if item is Item:
			slot_scenes[i].display_item(item, amount)
		else:
			slot_scenes[i].clear_item()

func select_next():
	select_slot(selected_slot + 1)
	
func select_prev():
	select_slot(selected_slot - 1)

func select_slot(index: int):
	if index >= slot_count:
		index = 0
	elif index < 0:
		index = slot_count - 1
	
	slot_scenes[selected_slot].deselect()
	slot_scenes[index].select()
	selected_slot = index

func get_selected_item() -> Item:
	return slot_scenes[selected_slot].item
