extends Node

var is_loading_state: bool = false
var current_state: SaveGame

func get_save_path(index: int) -> String:
	return "user://savegame_"+ str(index) +".tres"

func save_file_exists(index: int) -> bool:
	return ResourceLoader.exists(get_save_path(index))

func save_game():
	if not current_state is SaveGame:
		current_state = SaveGame.new()
	
	current_state.last_scene_name = get_tree().current_scene.name
	
	var player = get_tree().get_first_node_in_group("player") as Player
	current_state.player_position = player.global_position
	current_state.player_direction = player.current_direction
	current_state.player_inventory = player.inventory
	
	current_state.minutes_passed = TimeManager.total_minutes_passed
	current_state.seconds_played = TimeManager.total_realtime_seconds_passed
	
	var location = get_tree().get_first_node_in_group("location")
	if location is Location:
		current_state.tilled_tiles_by_location[location.name] = location.soil_tiles
	
	var collected_object_data: Array[ObjectData] = []
	get_tree().call_group("saved_object", "on_save_game", collected_object_data)
	
	var new_object_data: Array[ObjectData] = []

	for item in current_state.object_data:
		if item.location_name != Global.current_location:
			new_object_data.append(item)
			
	new_object_data.append_array(collected_object_data)
	current_state.object_data = new_object_data
	
	if Global.current_location not in current_state.saved_locations:
		current_state.saved_locations.append(Global.current_location)
	
	var save_path = get_save_path(Global.current_save_file)
	ResourceSaver.save(current_state, save_path)

func load_game(index: int):
	var save_state: SaveGame
	var save_path = get_save_path(index)
	
	is_loading_state = true
	if ResourceLoader.exists(save_path):
		save_state = load(save_path) as SaveGame
	else:
		is_loading_state = false
		save_state = SaveGame.new() as SaveGame
	
	var scene_path = LocationManager.scenes[save_state.last_scene_name]
	if not scene_path:
		return
	
	current_state = save_state
	TimeManager.total_minutes_passed = current_state.minutes_passed
	TimeManager.total_realtime_seconds_passed = current_state.seconds_played
	
	var new_scene = load(scene_path)
	new_scene.instantiate()
	get_tree().call_deferred("change_scene_to_packed", new_scene)
	
	Global.current_location = save_state.last_scene_name
