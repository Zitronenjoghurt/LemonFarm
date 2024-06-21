extends Node2D

@export var item: Item

func _ready():
	var instance = item.dropped_scene.instantiate()
	add_child(instance)

func _on_area_2d_body_entered(body):
	if body is Player:
		body.on_item_picked_up(item)
		queue_free()
