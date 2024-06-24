extends Node2D

@export var item: Item

@onready var location = Global.current_location

func _ready():
	add_to_group("saved_object")
	if item is Item:
		display_item()

func _on_area_2d_body_entered(body):
	if body is Player:
		body.on_item_picked_up(item)
		queue_free()

func display_item():
	var instance = item.dropped_scene.instantiate()
	add_child(instance)

func on_save_game(saved_data: Array[ObjectData]):
	var my_data = DroppedItemObjectData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.location_name = location
	my_data.item = item
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(data: ObjectData):
	var my_data: DroppedItemObjectData = data as DroppedItemObjectData
	global_position = my_data.position
	item = my_data.item
	display_item()
