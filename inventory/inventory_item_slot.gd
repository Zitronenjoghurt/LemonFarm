extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var item_count: Label = %ItemCount

func display_item(item: Item, amount: int):
	texture_rect.texture = item.icon
	item_count.text = str(amount)
