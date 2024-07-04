# Resource for all farming plants
class_name Plant
extends Resource

@export var id: String
@export var name: String
@export var grow_time_per_stage: float # in in-game minutes
@export var product_item: Item
@export var growth_stages: Array[Texture2D]
@export var tall_stages: Array[int] = []
@export var min_light_level: float = 0
@export var min_yield: int = 1
@export var max_yield: int = 2
@export var unlocked_seed_recipe: String

static func get_by_id(id: String) -> Plant:
	var path = "res://plants/plant_data/" + id + ".tres"
	if not ResourceLoader.exists(path):
		return null
	
	var plant = ResourceLoader.load(path) as Plant
	return plant
