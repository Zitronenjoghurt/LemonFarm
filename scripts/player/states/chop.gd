extends State
class_name PlayerChop
const FD = Enums.FacingDirection

@export var sprite: AnimatedSprite2D
@export var player: Player
@export var axe_hitbox: AxeHitbox
@export var chop_frames: Array[int] = [5, 6, 7]

const ANIMATIONS = {
	FD.UP: "axe_up",
	FD.DOWN: "axe_down",
	FD.LEFT: "axe_left",
	FD.RIGHT: "axe_right"
}

const HitboxNames = {
	FD.UP: "AxeHitboxUp",
	FD.DOWN: "AxeHitboxDown",
	FD.LEFT: "AxeHitboxLeft",
	FD.RIGHT: "AxeHitboxRight"
}

func Enter():
	player.velocity = Vector2.ZERO
	
func Update(delta: float):
	sprite.play(ANIMATIONS[player.current_direction])
	
	if sprite.frame in chop_frames:
		enable_axe_hitbox()
	else:
		disable_axe_hitbox()
	
	if Input.is_action_just_released("Chop"):
		state_transition.emit(self, "Idle")

func enable_axe_hitbox():
	axe_hitbox.action_direction = player.current_direction
	var collission_shape = axe_hitbox.get_node(HitboxNames[player.current_direction])
	if collission_shape is CollisionShape2D:
		collission_shape.disabled = false

func disable_axe_hitbox():
	for child in axe_hitbox.get_children():
		if child is CollisionShape2D:
			child.disabled = true
	
func Exit():
	disable_axe_hitbox()
