extends Node

const scenes = {
	"home": preload("res://locations/home.tscn"),
	"east_land": preload("res://locations/east_land.tscn")
}

signal on_trigger_player_spawn

var destination_teleporter_id

func change_location(location_name, destination_id):
	var scene_to_load = scenes[location_name]
	if not scene_to_load:
		return
	
	TransitionScreen.transition()
	await TransitionScreen.on_faded_out
	destination_teleporter_id = destination_id
	get_tree().call_deferred("change_scene_to_packed", scene_to_load)

func trigger_player_spawn(position: Vector2, direction: Enums.FacingDirection):
	on_trigger_player_spawn.emit(position, direction)
