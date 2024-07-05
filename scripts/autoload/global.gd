extends Node

const main_menu_scene_path: String = "res://scenes/main_menu.tscn"

enum PlayerMoveBlocked {
	CRAFTING,
	DIALOGUE,
	INVENTORY,
	PAUSE
}

var player_move_blocked: SubscribedArray = SubscribedArray.new()
var in_dialogue: bool = false
var current_location: String = "home"
var paused: bool = false
var current_save_file: int = -1
var unlocked_recipes: Array[String] = []

# Initialized on start
var all_recipe_ids: Array[String] = []
var all_recipes: Array[Recipe] = []
var all_recipes_by_category: Dictionary = {}

func _ready():
	# Load all recipes on startup
	all_recipe_ids = Recipe.get_all_ids()
	all_recipes = Recipe.get_by_ids(all_recipe_ids)
	all_recipes_by_category = Recipe.map_recipes_to_categories(all_recipe_ids)

func unlock_recipe(recipe_id: String):
	if recipe_id not in unlocked_recipes:
		unlocked_recipes.append(recipe_id)
