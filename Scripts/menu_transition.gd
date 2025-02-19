extends ColorRect

var in_pos: float = -126.0
var out_pos: float = -1050.0
var speed: float = 30.0

func slide_in():
	while position.y < in_pos:
		position.y += speed
		await get_tree().create_timer(0.01).timeout

func slide_out():
	while position.y > out_pos:
		position.y -= speed
		await get_tree().create_timer(0.01).timeout
