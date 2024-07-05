class_name InventoryItemSlot
extends PanelContainer

@export var normal_panel: StyleBoxTexture
@export var focused_panel: StyleBoxTexture

@onready var texture_rect: TextureRect = %TextureRect
@onready var item_count: Label = %ItemCount

var index: int = -1
var focused: bool = false

signal slot_clicked(index: int, click_type: Enums.MouseClickType)

func set_index(new_index: int):
	index = new_index

func clear():
	texture_rect.texture = null
	item_count.text = ""

func display_item(item: Item, amount: int = 0):
	texture_rect.texture = item.icon
	item_count.text = str(amount)
	
func display_item_without_amount(item: Item):
	texture_rect.texture = item.icon
	item_count.text = ""
	
func overwrite_amount(amount: String):
	item_count.text = amount
	
func focus():
	focused = true
	add_theme_stylebox_override("panel", focused_panel)
	
func unfocus():
	focused = false
	add_theme_stylebox_override("panel", normal_panel)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_type = Enums.MouseClickType.LEFT_CLICK
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if Input.is_key_pressed(KEY_SHIFT):
				click_type = Enums.MouseClickType.SHIFT_LEFT_CLICK
			else:
				click_type = Enums.MouseClickType.LEFT_CLICK
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if Input.is_key_pressed(KEY_SHIFT):
				click_type = Enums.MouseClickType.SHIFT_RIGHT_CLICK
			else:
				click_type = Enums.MouseClickType.RIGHT_CLICK
		
		slot_clicked.emit(index, click_type)
