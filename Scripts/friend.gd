extends AnimatedSprite2D

func win():
	await get_tree().create_timer(randf_range(0, 0.3)).timeout
	play("checkpoint")
	await Signal(self, "animation_finished")
	play("grow")
	await Signal(self, "animation_finished")
	play("idle")
