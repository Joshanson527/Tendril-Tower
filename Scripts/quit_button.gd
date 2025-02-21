extends Button

var in_pos: float = 10.0
var out_pos: float = -175.0
var speed: float = 10.0

func slide_in():
	while position.x < in_pos:
		position.x += speed
		await get_tree().create_timer(0.01).timeout

func slide_out():
	while position.x > out_pos:
		position.x -= speed
		await get_tree().create_timer(0.01).timeout

func _on_pressed() -> void:
	await get_tree().create_timer(1).timeout
	var tree = get_tree()
	if tree:
		tree.quit()
