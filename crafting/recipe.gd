class_name Recipe
extends Resource

enum Category {
	NONE,
	ALL,
	PLANT
}

@export var id: String = "none"
@export var name: String = "no_name"
@export var description: String = "no_description"

@export var required_items: Array[Item] = []
@export var required_item_counts: Array[int] = []

@export var product_items: Array[Item] = []
@export var product_item_counts_min: Array[int] = []
@export var product_item_counts_max: Array[int] = []

@export var categories: Array[Category] = []

const RECIPE_BASE_PATH = "res://crafting/recipes/"

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
		var count = required_item_counts[i] * amount
		inventory.remove_item(item, count)
	
	for i in range(len(product_items)):
		var item = product_items[i]
		for j in range(amount):
			var count = RNG.randi_range(product_item_counts_min[i], product_item_counts_max[i])
			inventory.add_item(item, count)
	
	return true

static func get_by_id(id: String) -> Recipe:
	var path = RECIPE_BASE_PATH + id + ".tres"
	if not ResourceLoader.exists(path):
		return null
		
	var recipe = load(path)
	return recipe
	
static func get_by_ids(ids: Array[String]) -> Array[Recipe]:
	var recipes: Array[Recipe] = []
	for id in ids:
		var recipe = get_by_id(id)
		if not recipe is Recipe:
			continue
		recipes.append(recipe)
	return recipes

static func get_all_ids() -> Array[String]:
	var dir = DirAccess.open(RECIPE_BASE_PATH)
	if not dir:
		return []
		
	var names: Array[String] = []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name:
		if file_name != "." and file_name != ".." and !dir.current_is_dir() and file_name.ends_with(".tres"):
			file_name = file_name.substr(0, file_name.length() - 5)
			names.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	return names

static func map_recipes_to_categories(recipe_ids: Array[String]) -> Dictionary:
	var mapped_recipes: Dictionary = {}
	for id in recipe_ids:
		var recipe = get_by_id(id)
		if not recipe is Recipe:
			continue
		
		for category in recipe.categories:
			if category not in mapped_recipes:
				var recipe_list: Array[Recipe] = [recipe]
				mapped_recipes[category] = recipe_list
			else:
				mapped_recipes[category].append(recipe)
	return mapped_recipes
