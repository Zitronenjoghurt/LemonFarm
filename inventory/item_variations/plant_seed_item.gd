class_name PlantSeedItem
extends CursorItem

@export var plant: Plant
@export var random_plant_position_offset: float = 1.5

const plant_scene_path = "res://plants/farming_plant.tscn"
var RNG = RandomNumberGenerator.new()

func usable_on_cell(tilemap: TileMap, cell_coords: Vector2i) -> bool:
	var location = Utils.get_current_location()
	if not location is Location:
		return false
		
	if cell_coords in location.tiles_with_plant:
		return false
	
	var is_soil = tilemap.get_cell_source_id(location.soil_layer, cell_coords) > -1
	return is_soil

func use(tilemap: TileMap, cell_coords: Vector2i) -> bool:
	if not usable_on_cell(tilemap, cell_coords):
		return false
	
	var location = Utils.get_current_location()
	if not location is Location:
		return false
		
	var scene = load(plant_scene_path)
	var plant_scene = scene.instantiate() as FarmingPlant
	location.add_child(plant_scene)
	plant_scene.set_plant(plant)
	var position = tilemap.map_to_local(cell_coords)
	
	# Makes the plants seem less artificial
	var x_offset = RNG.randf_range(-random_plant_position_offset, random_plant_position_offset)
	var y_offset = RNG.randf_range(-random_plant_position_offset, random_plant_position_offset)
	position.x += x_offset
	position.y += y_offset
	
	plant_scene.global_position = position
	
	location.tiles_with_plant.append(cell_coords)
	return true
