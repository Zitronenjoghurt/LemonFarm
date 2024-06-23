extends Node

var is_loading_state: bool = false
var current_state: SaveGame

func get_save_path(index: int) -> String:
	return "user://savegame_"+ str(index) +".tres"

func save_game(index: int = 0):
	var save_state: SaveGame = SaveGame.new()
	
	save_state.last_scene_name = get_tree().current_scene.name
	
	var player = get_tree().get_first_node_in_group("player")
	save_state.player_position = player.global_position
	save_state.player_direction = player.current_direction
	
	var save_path = get_save_path(index)
	await ResourceSaver.save(save_state, save_path)

func load_game(index: int = 0):
	var save_state: SaveGame
	var save_path = get_save_path(index)
	
	if ResourceLoader.exists(save_path):
		save_state = load(save_path) as SaveGame
	else:
		save_state = SaveGame.new() as SaveGame
	
	var scene_to_load = LocationManager.scenes[save_state.last_scene_name]
	if not scene_to_load:
		return
	get_tree().call_deferred("change_scene_to_packed", scene_to_load)
	
	is_loading_state = true
	current_state = save_state
