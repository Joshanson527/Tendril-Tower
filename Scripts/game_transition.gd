extends ColorRect

signal respawn_fade()

func _ready():
	fade_out()

func fade_in():
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(material, "shader_parameter/height", 1.5, 1.0)

func fade_out():
	var tween := get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(material, "shader_parameter/height", -1.5, 1.0)

func _on_quit_pressed():
	fade_in()

func _on_character_respawn():
	fade_in()
	await get_tree().create_timer(1).timeout
	fade_out()
	await get_tree().create_timer(1).timeout
	emit_signal("respawn_fade")
