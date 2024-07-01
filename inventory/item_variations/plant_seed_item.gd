class_name PlantSeedItem
extends CursorItem

@export var plant: Plant

const plant_scene_path = "res://plants/farming_plant.tscn"

func usable_on_cell(tilemap: TileMap, cell_coords: Vector2i) -> bool:
	var location = Utils.get_current_location()
	if not location is Location:
		return false
		
	if cell_coords in location.tiles_with_plant:
		return false
	
	var is_soil = tilemap.get_cell_source_id(location.soil_layer, cell_coords) > -1
	return is_soil

func use(tilemap: TileMap, cell_coords: Vector2i):
	if not usable_on_cell(tilemap, cell_coords):
		return
	
	var location = Utils.get_current_location()
	if not location is Location:
		return false
		
	var scene = load(plant_scene_path)
	var plant_scene = scene.instantiate() as FarmingPlant
	plant_scene.plant = plant
	plant_scene.global_position = tilemap.map_to_local(cell_coords)
	
	location.add_child(plant_scene)
	location.tiles_with_plant.append(cell_coords)
