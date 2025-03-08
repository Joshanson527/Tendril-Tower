extends TextureButton

@onready var ui: Control = $".."
@onready var transition: ColorRect = $"../Transition"
@onready var level_base = preload("res://Scenes/game.tscn")
@onready var level_1 = preload("res://Scenes/level_1.tscn")
@onready var level_2 = preload("res://Scenes/level_2.tscn")

var press_delay: bool = false

func _on_button_pressed():
	if press_delay == true:
		return
	press_delay = true
	transition.fade_in()
	await get_tree().create_timer(1).timeout
	
	var tree = get_tree()
	if tree:
		var world = level_base.instantiate()
		world.name = "World"
		
		var level
		if name == "Level1":
			level = level_1.instantiate()
		elif name == "Level2":
			level = level_2.instantiate()
		level.name = "Level"
			
		world.add_child(level)
		
		ui.hide()
		get_node("../..").add_child(world)
		
		await tree.create_timer(3).timeout
		press_delay = false
