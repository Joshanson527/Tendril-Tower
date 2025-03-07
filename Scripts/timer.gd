extends Label

@onready var level: Node2D = $"../../../Level"

var time

var elapsed_time: float = 0.0
var is_stopped: bool = false

var level_ready: bool = false

func _ready():
	while level == null:
		pass
	
	text = str(0.00)
	is_stopped = false
	init()

func init():
	time = level.time_counter
	level_ready = true

func _process(delta: float):
	if !level_ready:
		return
	
	if !is_stopped:
		elapsed_time += delta
		self.text = format_time(elapsed_time)
		time.text = "Time: " + self.text

func stop():
	is_stopped = true
	get_parent().hide()

func format_time(time: float) -> String:
	var seconds: float = fmod(time, 60.0)
	var minutes: int = int(time / 60.0)
	return str(minutes) + ":" + str(seconds).pad_decimals(2)
