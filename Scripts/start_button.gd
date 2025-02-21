extends Button

@onready var transition := $"../Transition"

func _on_pressed() -> void:
	transition.fade_in()
	await get_tree().create_timer(1).timeout
	
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://Scenes/game.tscn")
