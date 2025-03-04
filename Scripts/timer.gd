extends Label

@onready var time: Label = $"../../../time"

var elapsed_time: float = 0.0
var is_stopped: bool = false

func _ready():
	text = str(0.00)
	is_stopped = false

func _process(delta: float):
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
