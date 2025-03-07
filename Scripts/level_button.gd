extends TextureButton

@onready var ui: Control = $".."
@onready var transition: ColorRect = $"../Transition"
@onready var level_base = preload("res://Scenes/game.tscn")
@onready var level_1 = preload("res://Scenes/level_1.tscn")

var press_delay: bool = false

func _on_level_1_pressed():
	if press_delay == true:
		return
	press_delay = true
	transition.fade_in()
	await get_tree().create_timer(1).timeout
	
	var tree = get_tree()
	if tree:
		var level = level_base.instantiate()
		var level1 = level_1.instantiate()
		level.name = "World"
		level1.name = "Level"
		level.add_child(level1)
		
		ui.hide()
		get_node("../..").add_child(level)
		
		await get_tree().create_timer(3).timeout
		press_delay = false
