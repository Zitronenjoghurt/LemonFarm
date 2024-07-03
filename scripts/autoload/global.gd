extends Node

const main_menu_scene_path: String = "res://scenes/main_menu.tscn"

enum PlayerMoveBlocked {
	DIALOGUE,
	INVENTORY,
	PAUSE
}

var player_move_blocked: SubscribedArray = SubscribedArray.new()
var in_dialogue: bool = false
var current_location: String = "home"
var paused: bool = false
var current_save_file: int = -1
