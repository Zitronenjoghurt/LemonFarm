extends State
class_name PlayerTill
const FD = Enums.FacingDirection

@export var sprite: AnimatedSprite2D
@export var player: Player

@export var till_position_offset: Vector2 = Vector2.ZERO

@export var till_time_sec: float = 0.475 # How many seconds you have to till so the cell gets tilled
var _till_time_cum: float = 0 

const ANIMATIONS = {
	FD.UP: "till_up",
	FD.DOWN: "till_down",
	FD.LEFT: "till_left",
	FD.RIGHT: "till_right"
}

func Enter():
	player.velocity = Vector2.ZERO
	
func Update(delta: float):
	sprite.play(ANIMATIONS[player.current_direction])
	
	if not Input.is_action_pressed("Till"):
		state_transition.emit(self, "Idle")
	
	if Input.is_action_pressed("Up"):
		player.current_direction = FD.UP
	elif Input.is_action_pressed("Down"):
		player.current_direction = FD.DOWN
	elif Input.is_action_pressed("Left"):
		player.current_direction = FD.LEFT
	elif Input.is_action_pressed("Right"):
		player.current_direction = FD.RIGHT
		
	_till_time_cum += delta
	if _till_time_cum > till_time_sec:
		_till_time_cum = 0
		till_cell()
		state_transition.emit(self, "Idle")

func till_cell():
	var tile_map: TileMap = get_tree().get_first_node_in_group("tile_map") as TileMap
	if not tile_map is TileMap:
		return
		
	var location: Location = get_tree().get_first_node_in_group("location") as Location
	if not location is Location:
		return
	
	var player_cell_coords = tile_map.local_to_map(player.global_position + till_position_offset)
	var target_cell_coords = get_target_cell(player_cell_coords)
	
	var cell_tillable = tile_map.get_cell_tile_data(location.ground_layer, target_cell_coords).get_custom_data("tillable")
	if not cell_tillable:
		return
		
	var highest_layer = Utils.get_highest_layer_at_cell(tile_map, target_cell_coords)
	if highest_layer > location.soil_layer:
		return
	
	location.place_soil_tile(target_cell_coords)
	
func get_target_cell(player_cell: Vector2i) -> Vector2i:
	match player.current_direction:
		FD.UP:
			return Vector2i(player_cell.x, player_cell.y - 1)
		FD.DOWN:
			return Vector2i(player_cell.x, player_cell.y + 1)
		FD.LEFT:
			return Vector2i(player_cell.x - 1, player_cell.y)
		FD.RIGHT:
			return Vector2i(player_cell.x + 1, player_cell.y)
	return player_cell

func Exit():
	_till_time_cum = 0
