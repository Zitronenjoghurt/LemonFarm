extends Node

func is_direction_key_pressed() -> bool:
	return Input.is_action_pressed("Up") or Input.is_action_pressed("Down") or Input.is_action_pressed("Left") or Input.is_action_pressed("Right")

func is_running() -> bool:
	return Input.is_action_pressed("Run")

func get_highest_layer_at_cell(tilemap: TileMap, cell_coords: Vector2i) -> int:
	var highest_layer = -1
	for layer in range(tilemap.get_layers_count()):
		if tilemap.get_cell_source_id(layer, cell_coords) > -1:
			highest_layer = layer
	return highest_layer
