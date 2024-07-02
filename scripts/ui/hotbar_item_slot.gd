class_name HotBarItemSlot
extends PanelContainer

@export var texture_normal: StyleBoxTexture
@export var texture_selected: StyleBoxTexture
@export var item: Item = null

@onready var icon: TextureRect = %Icon
@onready var label: Label = %Label

var selected: bool = false

func _ready():
	add_theme_stylebox_override("panel", texture_normal)
	var t = 1

func select():
	add_theme_stylebox_override("panel", texture_selected) 
	selected = true

func deselect():
	add_theme_stylebox_override("panel", texture_normal)
	selected = false

func display_item(new_item: Item, amount: int):
	if not new_item is Item:
		return
		
	item = new_item
	icon.texture = item.icon
	label.text = str(amount)

func clear_item():
	item = null
	icon.texture = null
	label.text = ""
