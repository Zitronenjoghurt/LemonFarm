extends CharacterBody2D
class_name Player
const FD = Enums.FacingDirection

@export var fsm: StateManager
var current_direction: FD = FD.DOWN
var speed = 50
var run_speed_multiplier = 2

func _physics_process(delta):
	move_and_slide()
