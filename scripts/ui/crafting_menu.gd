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
@onready var x1_button: Button = %x1
@onready var x5_button: Button = %x5
@onready var x10_button: Button = %x10
@onready var x25_button: Button = %x25
@onready var x100_button: Button = %x100

@onready var craft_buttons: Array[Button] = [x1_button, x5_button, x10_button, x25_button, x100_button]
var craft_button_count: Array[int] = [1, 5, 10, 25, 100]

@onready var category_to_tab_button: Dictionary = {
	Recipe.Category.ALL: %AllButton,
	Recipe.Category.PLANT: %PlantsButton
}

var current_category: Recipe.Category = Recipe.Category.NONE
var current_recipes: Array[Recipe] = []
var recipe_slot_scenes: Array[InventoryItemSlot] = []
var recipe_information_slot_scenes: Array[InventoryItemSlot] = []

var current_selected_index: int = -1
var player_inventory: Inventory = Inventory.new()

signal has_crafted
signal closed

func _ready():
	for i in range(len(craft_buttons)):
		var button = craft_buttons[i]
		var count: int = craft_button_count[i]
		button.pressed.connect(_on_craft_button_pressed.bind(count))
		
	for category in category_to_tab_button.keys():
		var button = category_to_tab_button[category]
		button.pressed.connect(_on_category_button_pressed.bind(category))

func open(inventory: Inventory):
	player_inventory = inventory
	display_category()
	show()
	MouseManager.visible(MouseManager.VisibilitySource.CRAFTING_MENU)
	Global.player_move_blocked.subscribe(Global.PlayerMoveBlocked.CRAFTING)
	
func close():
	hide()
	MouseManager.hidden(MouseManager.VisibilitySource.CRAFTING_MENU)
	Global.player_move_blocked.unsubscribe(Global.PlayerMoveBlocked.CRAFTING)
	closed.emit()
	
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
	
	if current_category != Recipe.Category.NONE:
		category_to_tab_button[current_category].button_pressed = false
		category_to_tab_button[current_category].disabled = false
	category_to_tab_button[category].button_pressed = true
	category_to_tab_button[category].disabled = true
	
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
		
	clear_recipe()

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
	
	if current_selected_index >= 0:
		recipe_slot_scenes[current_selected_index].unfocus()
	current_selected_index = index
	recipe_slot_scenes[current_selected_index].focus()
	update_craft_buttons()
	
func clear_recipe():
	clear_recipe_information()
	current_selected_index = -1
	update_craft_buttons()
	
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
	unload_item_slots(recipe_information_slot_scenes)
	recipe_information_slot_scenes = []
	
func update_craft_buttons():
	if current_selected_index == -1:
		disable_craft_buttons()
		return
	
	var recipe = current_recipes[current_selected_index]
	var disabled = false
	for i in range(len(craft_buttons)):
		var button = craft_buttons[i]
		if disabled:
			button.disabled = true
			continue
		else:
			button.disabled = false
		
		var count = craft_button_count[i]
		if not recipe.inventory_can_craft(player_inventory, count):
			disabled = true
			button.disabled = true
			
func disable_craft_buttons():
	for button in craft_buttons:
		button.disabled = true

func _on_craft_button_pressed(count: int):
	if current_selected_index == -1:
		return
		
	var recipe = current_recipes[current_selected_index]
	var _success = recipe.craft_for_inventory(player_inventory, count)
	has_crafted.emit()
	update_craft_buttons()

func _on_category_button_pressed(category: Recipe.Category):
	display_category(category)

func _on_close_button_pressed():
	close()
