extends Node2D
class_name Location

@onready var player: Player = %Player

func _ready():
	if SaveManager.is_loading_state:
		apply_save_state()
	
	if LocationManager.destination_teleporter_id != null:
		_on_teleporter_spawn(LocationManager.destination_teleporter_id)

func apply_save_state():
	if not SaveManager.current_state is SaveGame:
		return
	
	var state = SaveManager.current_state as SaveGame
	player.global_position = state.player_position
	player.current_direction = state.player_direction

func _on_teleporter_spawn(teleporter_id: int):
	var teleporter_path = "Teleporter_" + str(teleporter_id)
	var teleporter = get_node(teleporter_path) as Teleporter
	LocationManager.trigger_player_spawn(teleporter.spawn_point.global_position, teleporter.spawn_direction)
