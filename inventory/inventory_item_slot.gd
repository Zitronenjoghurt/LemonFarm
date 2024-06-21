extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect

func display_item(item: Item):
	texture_rect.texture = item.icon
