extends ColorRect

var in_pos: float = -500.0
var out_pos: float = -1300.0
var speed: float = 30.0

func _ready():
	slide_out()

func slide_in():
	while position.y < in_pos:
		position.y += speed
		await get_tree().create_timer(0.01).timeout

func slide_out():
	while position.y > out_pos:
		position.y -= speed
		await get_tree().create_timer(0.01).timeout

func _on_quit_pressed() -> void:
	slide_in()
