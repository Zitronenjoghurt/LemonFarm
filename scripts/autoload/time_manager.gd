extends Node

var timescale: float = 1.0
var seconds_per_minute: int = 1 # How many real-time seconds equal 1 in-game minute
var minutes_per_hour: int = 60  # How many in-game minutes equal 1 in-game hour
var hours_per_day: int = 24     # How many in-game hours equal to 1 in-game day

var total_minutes_passed: int = 0 # How many minutes have passed in total

var _delta_cum: float = 0 # Cumulative delta time
var _minutes_passed: int = 0

signal tick_minute(day: int, hour: int, minute: int) # Ticks every in-game minute
signal tick_hour(day: int, hour: int, minute: int) # Ticks every in-game hour

func _process(delta):
	_delta_cum += delta * timescale
	
	while _delta_cum >= seconds_per_minute:
		_delta_cum -= seconds_per_minute
		process_minute()
		
func process_minute():
	var time = get_time()
	
	tick_minute.emit(time[0], time[1], time[2])
	_minutes_passed += 1
	total_minutes_passed += 1
	
	while _minutes_passed >= minutes_per_hour:
		_minutes_passed -= minutes_per_hour
		process_hour(time)
		
func process_hour(time: Array):
	tick_hour.emit(time[0], time[1], time[2])

# Returns the time in [day, hour, minute]
func get_time() -> Array:
	var mins = total_minutes_passed
	
	var minutes_per_day = minutes_per_hour * hours_per_day
	var days = int(mins / minutes_per_day)
	mins -= days * minutes_per_day
	
	var hours = int(mins / minutes_per_hour)
	mins -= hours * minutes_per_hour
	
	return [int(days), int(hours), int(mins)]

# Returns the current light level between 0 and 1
func get_light_level() -> float:
	return 0.5 * sin((2*PI*total_minutes_passed)/(minutes_per_hour*hours_per_day)-(PI/2))+0.5
