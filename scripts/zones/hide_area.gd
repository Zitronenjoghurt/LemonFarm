extends TransformArea
class_name HideArea

func _transform(node: Node2D):
	node.hide()

func _untransform(node):
	node.show()
