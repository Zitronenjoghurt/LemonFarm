# Will randomly drop items in the specified area
# Only works with a rectangle and circle collission shape
class_name RandomDropArea
extends Area2D

@onready var drop_area: CollisionShape2D = $DropArea

@export var items: Array[Item] = []
@export var item_min_count: Array[int] = []
@export var item_max_count: Array[int] = []
@export var dropped_item_scene: PackedScene

var has_dropped: bool = false
var RNG = RandomNumberGenerator.new()

func drop():
	if has_dropped:
		return
	
	var location = get_tree().get_first_node_in_group("location")
	if not location is Location:
		return
	
	var item_counts = []
	var total_count = 0
	for i in range(len(items)):
		var random_count = RNG.randi_range(item_min_count[i], item_max_count[i])
		item_counts.append(random_count)
		total_count += random_count
	
	var coords = generate_coords(total_count)
	if len(coords) != total_count:
		return
	
	for i in range(len(items)):
		var item = items[i]
		var spawn_count = item_counts[i]
		for j in range(spawn_count):
			var position = coords.pop_front()
			spawn_item(location, item, position)
			
	has_dropped = true

func spawn_item(target_node: Node, item: Item, position: Vector2):
	var scene = dropped_item_scene.instantiate()
	scene.item = item
	scene.global_position = position
	target_node.add_child(scene)
	scene.display_item()

func generate_coords(count: int) -> Array[Vector2]:
	if drop_area.shape is CircleShape2D:
		return random_coords_circle(count, drop_area.shape.radius)
	elif drop_area.shape is RectangleShape2D:
		return random_coords_rect(count, drop_area.shape.size)
	return []

func random_coords_circle(count: int, radius: float) -> Array[Vector2]:
	var coords: Array[Vector2] = []
	for i in range(count):
		var theta = RNG.randf_range(0, 2*PI)
		# u will help for even distribution of points on the area
		var u = RNG.randf_range(0, 1)
		var r = radius * sqrt(u)
		
		var x = r * cos(theta)
		var y = r * sin(theta)
		var position = global_from_local(Vector2(x, y))
		coords.append(position)
	return coords

func random_coords_rect(count: int, size: Vector2) -> Array[Vector2]:
	var coords: Array[Vector2] = []
	for i in range(count):
		var x_half = size.x / 2
		var y_half = size.y / 2
		
		var x = RNG.randf_range(-x_half, x_half)
		var y = RNG.randf_range(-y_half, y_half)
		var position = global_from_local(Vector2(x, y))
		coords.append(position)
	return coords

func global_from_local(local: Vector2) -> Vector2:
	return Vector2(local.x + global_position.x, local.y + global_position.y)
