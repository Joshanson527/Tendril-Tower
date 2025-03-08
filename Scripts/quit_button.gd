extends TextureButton

var next_scene = load("res://Scenes/menu.tscn")

var in_pos: float = -40.0
var out_pos: float = -250.0
var speed: float = 10.0

func slide_in():
	while position.x < in_pos:
		position.x += speed
		await get_tree().create_timer(0.01).timeout

func slide_out():
	while position.x > out_pos:
		position.x -= speed
		await get_tree().create_timer(0.01).timeout

func _on_pressed():
	await get_tree().create_timer(1).timeout
	
	var tree = get_tree()
	if name == "QuitButton" and tree:
		tree.quit()
	elif tree:
		tree.paused = false
		tree.change_scene_to_packed(next_scene)
