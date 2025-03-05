extends TextureButton

@onready var transition := $"../AnimatedSprite2D/Camera2D/Transition"

var next_scene = preload("res://Scenes/game.tscn")

func _process(_delta):
	grab_focus()
	if (Input.is_action_just_pressed("1")):
		next_scene = preload("res://Scenes/game.tscn")
	if (Input.is_action_just_pressed("2")):
		next_scene = preload("res://Scenes/level2.tscn")
	if (Input.is_action_just_pressed("3")):
		next_scene = preload("res://Scenes/challenge.tscn")

func _on_pressed() -> void:
	transition.fade_in()
	await get_tree().create_timer(1).timeout
	
	var tree = get_tree()
	if tree:
		tree.change_scene_to_packed(next_scene)
