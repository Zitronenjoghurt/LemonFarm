extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("home_bed")

func _on_timeline_ended():
	InteractionManager.can_interact = true
