class_name Inventory
extends Resource

@export var _slot_id: Dictionary = {}
@export var _slot_amount: Dictionary = {}
@export var _total_slot_count: int = 18
@export var _stack_size: int = 999

# If slot_index is -1, a free slot has to be found
# Returns true if item was successfully added, false if not
func add_item(item: Item, amount: int = 1, slot_index: int = -1) -> bool:
	var index = slot_index
	if index == -1:
		index = _slot_id.find_key(item.id)
	if index == null:
		index = next_free_index()
	if index == -1:
		return false
	
	if index in _slot_id:
		# Recursively handle overflowing items
		var item_exists_at_index = _slot_id[index] == item.id
		var stack_would_overflow = _slot_amount[index] + amount > _stack_size
		if item_exists_at_index and stack_would_overflow:
			var fitting_amount = _stack_size - _slot_amount[index]
			var overflowing_amount = amount - fitting_amount
			amount = fitting_amount
			
			var overflow_index = next_pushable_stack_or_free_index(item, [index])
			if overflow_index == -1:
				return false
				
			var success = add_item(item, overflowing_amount, overflow_index)
			if not success:
				return false
		
		_slot_amount[index] += amount
	else:
		_slot_id[index] = item.id
		_slot_amount[index] = amount
	
	return true

func next_free_index() -> int:
	for i in range(_total_slot_count):
		if i not in _slot_id:
			return i
	return -1
	
func next_pushable_stack_or_free_index(item: Item, excluded_indices: Array[int]) -> int:
	for i in range(_total_slot_count):
		if i not in _slot_id or i in excluded_indices:
			continue
		
		if _slot_id[i] == item.id and _slot_amount[i] < _stack_size:
			return i
	
	return next_free_index()
	
func count_items(item: Item) -> int:
	var count = 0
	
	for index in _slot_id:
		var item_id = _slot_id[index]
		if item.id != item_id:
			continue
		var item_count = _slot_amount[index]
		count += item_count
	
	return count
	
func has_items(item: Item, amount: int) -> bool:
	var count = count_items(item)
	return count >= amount

# Removes as much of the given item as possible.
# Because of the recursive nature, its best to check if 
# the inventory has enough of the given item before removing
func remove_item(item: Item, amount: int = 1):
	var index = _slot_id.find_key(item.id)
	if index == null:
		return
	
	if amount < _slot_amount[index]:
		_slot_amount[index] -= amount
	elif amount == _slot_amount[index]:
		_slot_id.erase(index)
		_slot_amount.erase(index)
	else:
		var remaining_amount = amount - _slot_amount[index]
		_slot_id.erase(index)
		_slot_amount.erase(index)
		remove_item(item, remaining_amount)

func remove_item_at_slot(index: int, amount: int) -> bool:
	if index not in _slot_id or amount > _slot_amount[index]:
		return false
	
	if amount == _slot_amount[index]:
		_slot_id.erase(index)
		_slot_amount.erase(index)
	else:
		_slot_amount[index] -= amount
	
	return true
	
func clear_slot(index: int):
	if index not in _slot_id:
		return
	
	_slot_id.erase(index)
	_slot_amount.erase(index)
	
func get_slot_count() -> int:
	return _total_slot_count
	
func get_empty_slot_count() -> int:
	var count = 0
	for i in range(_total_slot_count):
		var item = get_item_at_slot(i)
		if item == null:
			count += 1
	return count
	
func get_item_at_slot(index: int) -> Item:
	if index not in _slot_id:
		return null
	return get_item_by_id(_slot_id[index])
	
func get_amount_at_slot(index: int) -> int:
	if index not in _slot_id:
		return 0
	return _slot_amount[index]
	
func could_fit_items(items: Array[Item], amounts: Array[int]) -> bool:
	var empty_slots = get_empty_slot_count()
	
	for i in range(len(items)):
		# Preemptively end function if the items do already not fit
		if empty_slots < 0:
			return false
			
		var item = items[i]
		var amount = amounts[i]
		
		var current_amount = count_items(item)
		if current_amount == 0:
			empty_slots -= 1
			continue
			
		var current_stacks = int(current_amount / _stack_size)
		var new_stacks = int((current_amount + amount) / _stack_size)
		
		if current_stacks != new_stacks:
			empty_slots -= (new_stacks - current_stacks)
			
	if empty_slots < 0:
		return false
	return true

func get_item_path(id: String) -> String:
	return "res://inventory/item_data/" + id + ".tres"

func get_item_by_id(id: String) -> Item:
	var path = get_item_path(id)
	if not ResourceLoader.exists(path):
		path = get_item_path("none")
	
	var item = ResourceLoader.load(path) as Item
	return item
