extends StaticBody2D

enum Facing {
	LEFT,
	RIGHT,
	FRONT
}

@export var current_orientation: Facing = Facing.FRONT
@export var inventory: Inventory = Inventory.new()

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var left_collision: CollisionShape2D = %LeftCollision
@onready var right_collision: CollisionShape2D = %RightCollision
@onready var front_collision: CollisionShape2D = %FrontCollision
@onready var interaction_area: InteractionArea = %InteractionArea

func _ready():
	add_to_group("saved_object")
	interaction_area.interact = Callable(self, "_on_interact")
	match current_orientation:
		Facing.LEFT:
			left_collision.show()
			sprite.play("left_closed")
		Facing.RIGHT:
			right_collision.show()
			sprite.play("left_closed")
			sprite.flip_v = true
		Facing.FRONT:
			front_collision.show()
			sprite.play("front_closed")
			
func _on_interact():
	Global.player_can_move = false
	Global.in_dialogue = true

func on_save_game(saved_data: Array[ObjectData]):
	var my_data = ChestObjectData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.location_name = Global.current_location
	my_data.inventory = inventory
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(data: ObjectData):
	var my_data: ChestObjectData = data as ChestObjectData
	global_position = my_data.position
	inventory = my_data.inventory
