extends State
class_name PlayerTill
const FD = Enums.FacingDirection

@export var sprite: AnimatedSprite2D
@export var player: Player

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

func Exit():
	pass
