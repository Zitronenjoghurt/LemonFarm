class_name Recipe
extends Resource

@export var id: String = "none"
@export var name: String = "no_name"
@export var description: String = "no_description"

@export var required_items: Array[Item] = []
@export var required_item_counts: Array[int] = []

@export var product_items: Array[Item] = []
@export var product_item_counts_min: Array[int] = []
@export var product_item_counts_max: Array[int] = []

var RNG = RandomNumberGenerator.new()

func inventory_can_craft(inventory: Inventory, amount: int = 1) -> bool:
	for i in range(len(required_items)):
		var item = required_items[i]
		var count = required_item_counts[i] * amount
		if not inventory.has_items(item, count):
			return false
	
	if not inventory.could_fit_items(product_items, product_item_counts_max):
		return false
	
	return true

func craft_for_inventory(inventory: Inventory, amount: int = 1) -> bool:
	if not inventory_can_craft(inventory, amount):
		return false
	
	for i in range(len(required_items)):
		var item = required_items[i]
		var count = required_item_counts[i]
		inventory.remove_item(item, count)
	
	for i in range(len(product_items)):
		var item = product_items[i]
		var count = RNG.randi_range(product_item_counts_min[i], product_item_counts_max[i])
		inventory.add_item(item, count)
	
	return true
