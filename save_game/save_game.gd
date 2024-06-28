class_name SaveGame
extends Resource

const FD = Enums.FacingDirection

@export var minutes_passed: int = 0
@export var last_scene_name: String = "home"
@export var player_position: Vector2 = Vector2(90, -30)
@export var player_direction: FD = FD.DOWN
@export var player_inventory: Inventory = Inventory.new()
@export var saved_locations: Array[String] = [] # All locations that pushed object_data at least once
@export var object_data: Array[ObjectData] = []
