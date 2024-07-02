# An item supposed to be able to be used on a tile
class_name CursorItem
extends Item

func usable_on_cell(tilemap: TileMap, cell_coords: Vector2i) -> bool:
	return false

# Returns true if 1 item is supposed to be consumed
func use(tilemap: TileMap, cell_coords: Vector2i) -> bool:
	return false
