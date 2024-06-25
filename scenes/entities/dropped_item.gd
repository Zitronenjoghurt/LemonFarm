extends Node2D

@export var item: Item
@export var attraction_speed: int = 150
@export var shrink_speed: float = 5.5

@onready var location = Global.current_location
var was_dropped: bool = false

func _ready():
	set_physics_process(false)
	add_to_group("saved_object")
	if item is Item:
		display_item()

func _on_collection_area_body_entered(body):
	if body is Player:
		body.on_item_picked_up(item)
		queue_free()
		
func _on_attraction_area_body_entered(body):
	if was_dropped:
		return
	
	if body is Player:
		start_attraction()

func start_attraction():
	set_physics_process(true)
	
func _physics_process(delta):
	var target = get_tree().get_first_node_in_group("player")
	if not target is Player:
		return
	
	var direction = (target.position - position).normalized()
	position += direction * attraction_speed * delta
	
	if scale.x > 0:
		scale.x -= shrink_speed * delta
	if scale.y > 0:
		scale.y -= shrink_speed * delta

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
