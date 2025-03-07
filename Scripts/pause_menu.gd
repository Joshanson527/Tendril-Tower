extends Control

@onready var blur := $Blur
@onready var quit_button := $QuitButton
@onready var player := $"../Character"
@onready var timer: Label = $"../CanvasLayer/TimerBox/Timer"

var moving: bool = false

#func _ready():
	#await get_tree().create_timer(1).timeout
	#player.set_process(true)
	#timer.set_process(true)

func _process(_delta):
	position = player.position + Vector2(-115.2, -80.8)
	
	if Input.is_action_just_pressed("pause") and !moving:
		var tree = get_tree()
		if tree:
			if !tree.paused:
				moving = true
				blur.material.set_shader_parameter('lod', 2.5)
				quit_button.slide_in()
				tree.paused = true
				await tree.create_timer(0.5).timeout
				moving = false
			else:
				moving = true
				blur.material.set_shader_parameter('lod', 0.0)
				quit_button.slide_out()
				tree.paused = false
				await tree.create_timer(0.5).timeout
				moving = false 
