extends CanvasModulate

var _running: bool = false
@export var gradient_color: GradientTexture1D

func _process(delta):
	if _running:
		color = gradient_color.gradient.sample(TimeManager.get_light_level())

func activate():
	_running = true

func deactivate():
	_running = false
	color = Color.WHITE
