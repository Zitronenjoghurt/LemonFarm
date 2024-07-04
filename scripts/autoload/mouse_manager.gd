# Will handle if mouse is visible or not
extends Node

# All sources that enabled mouse visibility
var visible_sources: Array[int] = []

enum VisibilitySource {
	CRAFTING_MENU,
	CURSOR_ITEM,
	INVENTORY,
	MAIN_MENU,
	PAUSE
}

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func visible(source: VisibilitySource):
	if source not in visible_sources:
		visible_sources.append(source)
	update_visibility()

func hidden(source: VisibilitySource):
	if source in visible_sources:
		visible_sources.erase(source)
	update_visibility()

func force_show():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func force_hide():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func update_visibility():
	if len(visible_sources) > 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
