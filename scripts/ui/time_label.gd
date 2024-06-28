extends Label

func _ready():
	TimeManager.tick_minute.connect(_update_time)

func _update_time(day: int, hour: int, minute: int):
	text = "Day " + str(day) + " ["+str(hour)+":"+str(minute)+"]"
