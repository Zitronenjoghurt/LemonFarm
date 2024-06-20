extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@export var x_offset: int = 0
@export var y_offset: int = 0

var interact: Callable = func():
	pass

func _on_body_entered(body):
	if body is Player:
		InteractionManager.register_area(self)

func _on_body_exited(body):
	if body is Player:
		InteractionManager.unregister_area(self)
