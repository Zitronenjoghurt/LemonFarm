extends Node
class_name TransformArea

func _ready():
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body is Player:
		var parent = get_parent()
		_transform(parent)

func _on_body_exited(body):
	if body is Player:
		var parent = get_parent()
		_untransform(parent)

func _transform(_node):
	pass
	
func _untransform(_node):
	pass
