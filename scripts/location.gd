extends Node2D
class_name Location

func _ready():
	if LocationManager.destination_teleporter_id != null:
		_on_location_spawn(LocationManager.destination_teleporter_id)

func _on_location_spawn(teleporter_id: int):
	var teleporter_path = "Teleporter_" + str(teleporter_id)
	var teleporter = get_node(teleporter_path) as Teleporter
	LocationManager.trigger_player_spawn(teleporter.spawn_point.global_position, teleporter.spawn_direction)
