extends TransformArea
class_name FadeArea

func _transform(node):
	if _can_fade(node):
		node.modulate.a = 0.5
	else:
		for child in node.get_children():
			_transform(child)

func _untransform(node):
	if _can_fade(node):
		node.modulate.a = 1
	else:
		for child in node.get_children():
			_untransform(child)

func _can_fade(node):
	return "modulate" in node
