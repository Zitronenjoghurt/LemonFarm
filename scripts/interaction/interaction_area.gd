extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@export var x_offset: int = 0
@export var y_offset: int = 0
@export var enabled: bool = true

var interact: Callable = func():
	pass

func _on_body_entered(body):
	if body is Player and enabled:
		InteractionManager.register_area(self)

func _on_body_exited(body):
	if body is Player:
		InteractionManager.unregister_area(self)

func enable():
	enabled = true
	
func disable():
	enabled = false
