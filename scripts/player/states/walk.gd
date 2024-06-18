extends State
class_name PlayerWalk
const FD = Enums.FacingDirection

@export var sprite: AnimatedSprite2D
@export var player: Player

const ANIMATIONS = {
	FD.UP: "walk_up",
	FD.DOWN: "walk_down",
	FD.LEFT: "walk_left",
	FD.RIGHT: "walk_right"
}

func Enter():
	pass
	
func Update(delta: float):
	sprite.play(ANIMATIONS[player.current_direction])
	
	if Input.is_action_pressed("Up"):
		player.current_direction = FD.UP
		player.velocity = Vector2(0, -player.speed)
	elif Input.is_action_pressed("Down"):
		player.current_direction = FD.DOWN
		player.velocity = Vector2(0, player.speed)
	elif Input.is_action_pressed("Left"):
		player.current_direction = FD.LEFT
		player.velocity = Vector2(-player.speed, 0)
	elif Input.is_action_pressed("Right"):
		player.current_direction = FD.RIGHT
		player.velocity = Vector2(player.speed, 0)
	else:
		state_transition.emit(self, "Idle")

func Exit():
	pass
