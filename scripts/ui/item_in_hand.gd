class_name ItemInHand
extends Sprite2D

func _ready():
	global_position = get_global_mouse_position()
	show()

func display(item: Item, amount: int):
	texture = item.icon
	%Label.text = str(amount)

func update_amount(amount: int):
	%Label.text = str(amount)

func _input(event):
	global_position = get_global_mouse_position()
