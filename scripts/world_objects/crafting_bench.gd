extends StaticBody2D

@onready var interaction_area: InteractionArea = %InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	var ui_root = get_tree().get_first_node_in_group("ui_root") as UIRoot
	if not ui_root is UIRoot:
		return
	ui_root.open_crafting_menu()
	
	if not ui_root.crafting_menu_closed.is_connected(_on_closed):
		ui_root.crafting_menu_closed.connect(_on_closed)

func _on_closed():
	InteractionManager.can_interact = true
