extends State
class_name PlayerIdle
const FD = Enums.FacingDirection

@export var sprite: AnimatedSprite2D
@export var player: Player

const ANIMATIONS = {
	FD.UP: "idle_up",
	FD.DOWN: "idle_down",
	FD.LEFT: "idle_left",
	FD.RIGHT: "idle_right"
}

func Enter():
	player.velocity = Vector2.ZERO
	
func Update(delta: float):
	sprite.play(ANIMATIONS[player.current_direction])
	
	if !Global.player_can_move:
		return
	
	if Utils.is_direction_key_pressed():
		state_transition.emit(self, "Walk")
	
	if Input.is_action_pressed("Till"):
		state_transition.emit(self, "Till")
	
func Exit():
	pass
