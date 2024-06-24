extends Node

# Previously used preload here, but in Godot 4.2.2 it could lead to corrupt scenes
const scenes = {
	"home": "res://locations/home.tscn",
	"east_island": "res://locations/east_island.tscn"
}

signal on_trigger_player_spawn

var destination_teleporter_id

func change_location(location_name, destination_id):
	var scene_path = scenes[location_name]
	if not scene_path:
		return
	
	TransitionScreen.transition()
	await TransitionScreen.on_faded_out
	
	var new_scene = load(scene_path)
	new_scene.instantiate()
	
	destination_teleporter_id = destination_id
	get_tree().call_deferred("change_scene_to_packed", new_scene)

func trigger_player_spawn(position: Vector2, direction: Enums.FacingDirection):
	on_trigger_player_spawn.emit(position, direction)
