extends TransformArea
class_name HideArea

func _transform(node):
	node.hide()

func _untransform(node):
	node.show()
