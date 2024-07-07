class_name TreePlant
extends StaticBody2D
const FD = Enums.FacingDirection

enum TreeState {
	MATURE,
	FALLING,
	STUMP
}

enum FallingDirection {
	LEFT,
	RIGHT
}

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var drop_area: RandomDropArea = %RandomDropArea
@export var falling_end_frame: int = 13

var _current_state: TreeState = TreeState.MATURE
var _falling_direction: FallingDirection = FallingDirection.LEFT
var _health = 25

func _on_chop_area_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area is AxeHitbox:
		on_chop(area)
		
func _ready():
	add_to_group("saved_object")

func _process(delta):
	if _current_state == TreeState.FALLING and sprite.frame == falling_end_frame:
		_current_state = TreeState.STUMP
		update_sprite()
		drop_area.drop()

func update_sprite():
	match _current_state:
		TreeState.MATURE:
			sprite.play("idle")
		TreeState.FALLING:
			play_falling_animation()
		TreeState.STUMP:
			sprite.play("stump")

func on_chop(axe: AxeHitbox):
	if _current_state != TreeState.MATURE:
		return
	
	_health -= axe.damage
	if _health > 0:
		sprite.play("hit")
	else:
		if axe.action_direction == FD.RIGHT:
			_falling_direction = FallingDirection.RIGHT
		play_falling_animation()
		_current_state = TreeState.FALLING

func play_falling_animation():
	sprite.play("falling")
	if _falling_direction == FallingDirection.RIGHT:
		sprite.flip_h = true

func on_save_game(saved_data: Array[ObjectData]):
	var my_data = TreeObjectData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.location_name = Global.current_location
	my_data.current_state = _current_state
	my_data.falling_directioon = _falling_direction
	my_data.health = _health
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(data: ObjectData):
	var my_data: TreeObjectData = data as TreeObjectData
	global_position = my_data.position
	_current_state = my_data.current_state
	_falling_direction = my_data.falling_directioon
	_health = my_data.health
	update_sprite()
