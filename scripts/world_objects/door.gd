extends StaticBody2D

var objects_inside: int = 0

func _ready():
	%Sprite.play("closed")

func _on_area_2d_body_entered(body):
	if not body is Player:
		return
		
	objects_inside += 1
	
	if objects_inside == 1:
		%Sprite.play("opening")

func _on_area_2d_body_exited(body):
	if not body is Player:
		return
	
	objects_inside -= 1
	if objects_inside < 1:
		%Sprite.play("closing")
		objects_inside = 0
