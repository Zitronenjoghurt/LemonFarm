extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

signal on_faded_out

const SPRITE_ANIMATIONS = ["A", "B", "C", "D", "E"]
var last_animation: String = "A"

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_out")
	
	var available_animations = SPRITE_ANIMATIONS.duplicate()
	available_animations.erase(last_animation)
	var random_animation = available_animations.pick_random()
	%RandomEmoji.play(random_animation)
	last_animation = random_animation

func _on_animation_finished(animation_name):
	if animation_name == "fade_out":
		on_faded_out.emit()
		animation_player.play("fade_in")
	else:
		color_rect.visible = false
