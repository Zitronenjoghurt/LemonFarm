extends Area2D
class_name Teleporter

@export var target_location_name: String
@export var destination_teleporter_id: int
@export var spawn_direction: Enums.FacingDirection

@onready var spawn_point = $SpawnPoint

func _on_body_entered(body):
	if body is Player:
		if body.has_moved:
			LocationManager.change_location(target_location_name, destination_teleporter_id)
