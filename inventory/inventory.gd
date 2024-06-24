class_name Inventory

var _content: Dictionary = {}

func add_item(item: Item, amount: int = 1):
	if item.id not in _content:
		_content[item.id] = amount
	else:
		_content[item.id] += amount

func remove_item(item: Item, amount: int = 1):
	if item.id not in _content:
		return
	
	_content[item.id] -= amount
	if _content[item.id] <= 0:
		_content.erase(item.id)
	
func get_items() -> Dictionary:
	return _content

func set_items(items: Dictionary):
	_content = items
	
func get_amount(id: String) -> int:
	if id not in _content:
		return 0
	return _content[id]

func get_item_path(id: String) -> String:
	return "res://inventory/item_data/" + id + ".tres"

func get_item_by_id(id: String) -> Item:
	var path = get_item_path(id)
	if not ResourceLoader.exists(path):
		path = get_item_path("none")
	
	var item = ResourceLoader.load(path) as Item
	return item
