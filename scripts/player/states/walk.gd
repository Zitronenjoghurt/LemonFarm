extends State
class_name PlayerWalk
const FD = Enums.FacingDirection

@export var sprite: AnimatedSprite2D
@export var player: Player

const WALK_ANIMATIONS = {
	FD.UP: "walk_up",
	FD.DOWN: "walk_down",
	FD.LEFT: "walk_left",
	FD.RIGHT: "walk_right"
}

const RUN_ANIMATIONS = {
	FD.UP: "run_up",
	FD.DOWN: "run_down",
	FD.LEFT: "run_left",
	FD.RIGHT: "run_right"
}

func Enter():
	pass
	
func Update(delta: float):
	var speed = player.speed
	player.has_moved = true
	
	if Utils.is_running():
		speed *= player.run_speed_multiplier
		sprite.play(RUN_ANIMATIONS[player.current_direction])
	else:
		sprite.play(WALK_ANIMATIONS[player.current_direction])
	
	if Input.is_action_pressed("Up"):
		player.current_direction = FD.UP
		player.velocity = Vector2(0, -speed)
	elif Input.is_action_pressed("Down"):
		player.current_direction = FD.DOWN
		player.velocity = Vector2(0, speed)
	elif Input.is_action_pressed("Left"):
		player.current_direction = FD.LEFT
		player.velocity = Vector2(-speed, 0)
	elif Input.is_action_pressed("Right"):
		player.current_direction = FD.RIGHT
		player.velocity = Vector2(speed, 0)
	else:
		state_transition.emit(self, "Idle")
		
	if Input.is_action_pressed("Till"):
		state_transition.emit(self, "Till")

func Exit():
	pass
