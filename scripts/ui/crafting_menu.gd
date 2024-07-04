class_name CraftingUI
extends PanelContainer

@export var item_slot: PackedScene
@onready var recipe_grid: GridContainer = %RecipeGridContainer
@onready var recipe_title: Label = %RecipeTitle
@onready var recipe_description: Label = %RecipeDescription
@onready var h_seperator: HSeparator = %HSeparator
@onready var recipe_items_container: HBoxContainer = %RecipeItemsContainer
@onready var ingredients_grid: GridContainer = %IngredientsGridContainer
@onready var products_grid: GridContainer = %ProductsGridContainer

var current_category: Recipe.Category = Recipe.Category.NONE
var current_recipes: Array[Recipe] = []
var recipe_slot_scenes: Array[InventoryItemSlot] = []
var recipe_information_slot_scenes: Array[InventoryItemSlot] = []

func _ready():
	open()

func open():
	display_category()
	show()
	MouseManager.visible(MouseManager.VisibilitySource.CRAFTING_MENU)

func close():
	hide()
	MouseManager.hidden(MouseManager.VisibilitySource.CRAFTING_MENU)

func display_category(category: Recipe.Category = Recipe.Category.ALL):
	var recipes: Array[Recipe] = []
	if category == Recipe.Category.ALL:
		recipes = Global.all_recipes
	elif category in Global.all_recipes_by_category:
		recipes = Global.all_recipes_by_category[category]
	else:
		return
	
	if current_category == category:
		return
	current_category = category
	current_recipes = recipes
	
	for slot in recipe_slot_scenes:
		slot.slot_clicked.disconnect(on_recipe_slot_clicked)
	unload_item_slots(recipe_slot_scenes)
	recipe_slot_scenes = []
	
	for i in range(len(recipes)):
		var recipe = recipes[i]
		var new_slot = display_recipe_slot(recipe)
		new_slot.slot_clicked.connect(on_recipe_slot_clicked)
		new_slot.set_index(i)

func display_recipe_slot(recipe: Recipe) -> InventoryItemSlot:
	if len(recipe.product_items) == 0:
		return
	var item = recipe.product_items[0]
	var new_slot = load_item_slot(recipe_grid)
	new_slot.display_item_without_amount(item)
	recipe_slot_scenes.append(new_slot)
	return new_slot

func load_item_slot(parent_node: Node) -> InventoryItemSlot:
	var scene = item_slot.instantiate()
	parent_node.add_child(scene)
	return scene

func unload_item_slots(scenes: Array[InventoryItemSlot]):
	for scene in scenes:
		scene.get_parent().remove_child(self)
		scene.queue_free()

func on_recipe_slot_clicked(index: int, click_type: Enums.MouseClickType):
	if index < 0 or index >= len(current_recipes):
		return
	var recipe = current_recipes[index]
	if recipe is Recipe:
		display_recipe_information(recipe)
	
func display_recipe_information(recipe: Recipe):
	recipe_title.text = recipe.name
	recipe_description.text = recipe.description
	h_seperator.show()
	
	unload_item_slots(recipe_information_slot_scenes)
	recipe_information_slot_scenes = []
	
	for i in range(len(recipe.required_items)):
		var item = recipe.required_items[i]
		var amount = recipe.required_item_counts[i]
		var scene = load_item_slot(ingredients_grid)
		scene.display_item(item, amount)
		recipe_information_slot_scenes.append(scene)
		
	for i in range(len(recipe.product_items)):
		var item = recipe.product_items[i]
		var amount_min = recipe.product_item_counts_min[i]
		var amount_max = recipe.product_item_counts_max[i]
		var scene = load_item_slot(products_grid)
		scene.display_item_without_amount(item)
		if amount_min == amount_max:
			scene.overwrite_amount(str(amount_min))
		else:
			scene.overwrite_amount(str(amount_min) + "-" + str(amount_max))
		recipe_information_slot_scenes.append(scene)
		
	recipe_items_container.show()

func clear_recipe_information():
	recipe_title.text = ""
	recipe_description.text = ""
	h_seperator.hide()
	recipe_items_container.hide()
