class_name CellIndicator
extends Node2D

@onready var panel: Panel = %Panel

func green():
	panel.modulate = Color.LIME_GREEN

func red():
	panel.modulate = Color.ORANGE_RED

func place_at_cell(tile_map: TileMap, cell_coords: Vector2i):
	var coords = tile_map.map_to_local(cell_coords)
	global_position = coords
