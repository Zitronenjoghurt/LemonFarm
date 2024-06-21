extends CharacterBody2D
class_name Player
const FD = Enums.FacingDirection

@export var fsm: StateManager
var current_direction: FD = FD.DOWN
var speed = 50
var run_speed_multiplier = 2

var inventory: Inventory = Inventory.new()

func _ready():
	LocationManager.on_trigger_player_spawn.connect(_on_spawn)

func _physics_process(delta):
	move_and_slide()

func _on_spawn(spawn_position: Vector2, direction: FD):
	self.global_position = spawn_position
	self.current_direction = direction

func on_item_picked_up(item: Item):
	inventory.add_item(item)
