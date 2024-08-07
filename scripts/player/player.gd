extends CharacterBody2D
class_name Player
const FD = Enums.FacingDirection

@export var fsm: StateManager
var current_direction: FD = FD.DOWN
var speed = 50
var run_speed_multiplier = 2
var has_moved = false

var inventory: Inventory = Inventory.new()

signal inventory_changed

func _ready():
	LocationManager.on_trigger_player_spawn.connect(_on_spawn)
	inventory = SaveManager.current_state.player_inventory

func _physics_process(delta):
	if not Global.player_move_blocked.is_active():
		move_and_slide()

func _on_spawn(spawn_position: Vector2, direction: FD):
	self.global_position = spawn_position
	self.current_direction = direction

func on_item_picked_up(item: Item):
	inventory.add_item(item)
	inventory_changed.emit()
