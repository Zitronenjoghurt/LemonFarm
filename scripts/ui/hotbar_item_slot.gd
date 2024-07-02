class_name HotBarItemSlot
extends PanelContainer

@export var texture_normal: StyleBoxTexture
@export var texture_selected: StyleBoxTexture
@export var item: Item = null

@onready var icon: TextureRect = %Icon

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

func display_item(new_item: Item):
	if not new_item is Item:
		return
		
	item = new_item
	icon.texture = item.icon

func clear_item():
	item = null
	icon.texture = null
