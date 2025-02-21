extends ColorRect

func _ready():
	fade_out()

func fade_in():
	var tween := get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/height", 1.0, 1.0)

func fade_out():
	var tween := get_tree().create_tween()
	tween.tween_property(material, "shader_parameter/height", -1.0, 1.0)
