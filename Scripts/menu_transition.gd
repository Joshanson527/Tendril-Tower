extends ColorRect

func fade_in():
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(material, "shader_parameter/height", 1.5, 1.0)

func fade_out():
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(material, "shader_parameter/height", -1.5, 1.0)
