class_name UIRoot
extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var inventory_dialog1: InventoryDialog = %InventoryDialog1
@onready var inventory_dialog2: InventoryDialog = %InventoryDialog2
@onready var pause_dialog: PauseDialog = %PauseDialog
@onready var hot_bar: HotBar = %Hotbar
@onready var crafting_menu: CraftingUI = %CraftingMenu

@export var cell_indicator_scene: PackedScene
var cell_indicator: CellIndicator = null

signal crafting_menu_closed

func _ready():
	add_to_group("ui_root")
	hot_bar.update_items(player.inventory)
	
	# Spawn cell indicator
	var scene = cell_indicator_scene.instantiate()
	call_deferred("add_sibling", scene)
	cell_indicator = scene
	
	player.inventory_changed.connect(_on_player_inventory_change)
	inventory_dialog1.inventory_updated.connect(_on_player_inventory_change)
	inventory_dialog2.inventory_updated.connect(_on_player_inventory_change)
	
	crafting_menu.has_crafted.connect(_on_player_inventory_change)
	crafting_menu.closed.connect(_on_crafting_menu_closed)
	
func _unhandled_input(event):
	if Global.in_dialogue:
		return
	
	if event.is_action_released("Inventory") and not Global.paused:
		if inventory_dialog1.visible:
			InventoryManager.on_inventory_closed()
		else:
			open_player_inventory()
	
	if event.is_action_released("Pause"):
		if pause_dialog.visible:
			pause_dialog.close()
		else:
			InventoryManager.on_inventory_closed()
			pause_dialog.open()
	
	if event.is_action_released("Hotbar_Next"):
		hot_bar.select_next()
	if event.is_action_released("Hotbar_Prev"):
		hot_bar.select_prev()
	if event.is_action_pressed("Slot_0"):
		hot_bar.select_slot(0)
	if event.is_action_pressed("Slot_1"):
		hot_bar.select_slot(1)
	if event.is_action_pressed("Slot_2"):
		hot_bar.select_slot(2)
	if event.is_action_pressed("Slot_3"):
		hot_bar.select_slot(3)
	if event.is_action_pressed("Slot_4"):
		hot_bar.select_slot(4)
	if event.is_action_pressed("Slot_5"):
		hot_bar.select_slot(5)
	if event.is_action_pressed("Slot_6"):
		hot_bar.select_slot(6)
	if event.is_action_pressed("Slot_7"):
		hot_bar.select_slot(7)
	if event.is_action_pressed("Slot_8"):
		hot_bar.select_slot(8)
	
	if event.is_action_pressed("Action"):
		var item = hot_bar.get_selected_item()
		if item is CursorItem:
			var tile_map = get_tree().get_first_node_in_group("tile_map") as TileMap
			var cell_coords = tile_map.local_to_map(tile_map.get_global_mouse_position())
			var consume = item.use(tile_map, cell_coords)
			
			if consume:
				player.inventory.remove_item_at_slot(hot_bar.selected_slot, 1)
				hot_bar.update_items(player.inventory)
			
func _process(delta):
	var item = hot_bar.get_selected_item()
	if item is CursorItem:
		if not cell_indicator.visible:
			MouseManager.visible(MouseManager.VisibilitySource.CURSOR_ITEM)
		cell_indicator.show()
		var tile_map = get_tree().get_first_node_in_group("tile_map") as TileMap
		var mouse_pos = tile_map.get_global_mouse_position()
		var cell_coords = tile_map.local_to_map(mouse_pos)
		cell_indicator.place_at_cell(tile_map, cell_coords)
		
		if item.usable_on_cell(tile_map, cell_coords):
			cell_indicator.green()
		else:
			cell_indicator.red()
	else:
		if cell_indicator.visible:
			MouseManager.hidden(MouseManager.VisibilitySource.CURSOR_ITEM)
		cell_indicator.hide()
	
func open_player_inventory():
	inventory_dialog1.open(player.inventory, "Inventory", "player")
	inventory_dialog1.horizontal_mode()

func open_secondary_inventory(inventory: Inventory, inventory_name: String, inventory_id: String):
	open_player_inventory()
	inventory_dialog2.open(inventory, inventory_name, inventory_id)
	inventory_dialog1.vertical_mode()
	inventory_dialog2.vertical_mode()

func open_crafting_menu():
	crafting_menu.open(player.inventory)

func _on_crafting_menu_closed():
	crafting_menu_closed.emit()

func _on_player_inventory_change():
	hot_bar.update_items(player.inventory)
