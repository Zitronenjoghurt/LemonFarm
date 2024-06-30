extends Node2D
class_name Location

@export var ground_layer: int = 1
@export var soil_layer: int = 4

@onready var player: Player = %Player
@onready var tile_map: TileMap = %TileMap

var soil_tiles: Array = []
const SOIL_TERRAIN_SET: int = 3

func _ready():
	add_to_group("location")
	tile_map.add_to_group("tile_map")
	DayNightModulate.activate()
	
	if SaveManager.is_loading_state:
		apply_save_state()
		SaveManager.is_loading_state = false
	
	if LocationManager.destination_teleporter_id != null:
		_on_teleporter_spawn(LocationManager.destination_teleporter_id)
		LocationManager.destination_teleporter_id = null
		
	load_saved_objects()

func apply_save_state():
	if not SaveManager.current_state is SaveGame:
		return
	
	var state = SaveManager.current_state as SaveGame
	player.global_position = state.player_position
	player.current_direction = state.player_direction
	
	if name in state.tilled_tiles_by_location:
		soil_tiles = state.tilled_tiles_by_location[name]
		update_soil_tiles()
	
func place_soil_tile(coords: Vector2i):
	if coords in soil_tiles:
		return
	soil_tiles.append(coords)
	update_soil_tiles()
	
func update_soil_tiles():
	%TileMap.set_cells_terrain_connect(soil_layer, soil_tiles, SOIL_TERRAIN_SET, 0)

func load_saved_objects():
	var state = SaveManager.current_state as SaveGame
	
	if name not in state.saved_locations:
		return
	
	get_tree().call_group("saved_object", "on_before_load_game")
	
	for item in state.object_data:
		if item.location_name != name:
			continue
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
	
func _on_teleporter_spawn(teleporter_id: int):
	var teleporter_path = "Teleporter_" + str(teleporter_id)
	var teleporter = get_node(teleporter_path) as Teleporter
	LocationManager.trigger_player_spawn(teleporter.spawn_point.global_position, teleporter.spawn_direction)
