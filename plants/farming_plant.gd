class_name FarmingPlant
extends Node2D

@onready var sprite: Sprite2D = %Sprite
@onready var drop_area: RandomDropArea = %RandomDropArea
@onready var interaction_area: InteractionArea = %InteractionArea
@export var sprite_y_offset_normal: int = -6
@export var sprite_y_offset_tall: int = -14
@export var plant: Plant
var age: int = 0
var current_stage: int = -1

func _ready():
	TimeManager.tick_minute.connect(_on_tick_minute)
	interaction_area.interact = Callable(self, "_on_interact")
	add_to_group("farming_plant")
	add_to_group("saved_object")
	update_growth_stage()

func set_plant(new_plant: Plant):
	plant = new_plant
	update_growth_stage()
	
	drop_area.items = [plant.product_item]
	drop_area.item_min_count = [plant.min_yield]
	drop_area.item_max_count = [plant.max_yield]
	
func _on_interact():
	drop_area.drop()
	get_parent().remove_child(self)
	queue_free()
	InteractionManager.can_interact = true
	
func _on_tick_minute(_day: int, _hour: int, _minute: int):
	if TimeManager.current_light_level >= plant.min_light_level:
		age += 1
		update_growth_stage()
	
func update_growth_stage():
	if not plant is Plant:
		return
	
	var stage = min(floor(int(age / plant.grow_time_per_stage)), len(plant.growth_stages) - 1)
	if stage != current_stage:
		current_stage = stage
		sprite.texture = plant.growth_stages[stage]
		if stage in plant.tall_stages:
			sprite.position.y = sprite_y_offset_tall
		else:
			sprite.position.y = sprite_y_offset_normal

func on_save_game(saved_data: Array[ObjectData]):
	var my_data = FarmingPlantObjectData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.location_name = Global.current_location
	my_data.plant_id = plant.id
	my_data.age = age
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(data: ObjectData):
	var my_data: FarmingPlantObjectData = data as FarmingPlantObjectData
	
	var farming_plant = Plant.get_by_id(my_data.plant_id)
	if not farming_plant is Plant:
		get_parent().remove_child(self)
		queue_free()
		return
	
	global_position = my_data.position
	age = my_data.age
	
	set_plant(farming_plant)

func collect_global_position(collection: Array[Vector2]):
	collection.append(global_position)
