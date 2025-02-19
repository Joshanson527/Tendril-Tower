extends Control

@onready var blur := $Blur
@onready var quit_button := $Quit

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var tree = get_tree()
		if tree:
			if !tree.paused:
				blur.material.set_shader_parameter('lod', 1.5)
				quit_button.slide_in()
				tree.paused = true
			else:
				blur.material.set_shader_parameter('lod', 0.0)
				quit_button.slide_out()
				tree.paused = false
