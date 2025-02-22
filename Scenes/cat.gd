extends AnimatedSprite2D

func _ready():
	flip_h = false

func notice():
	flip_h = true
	play("notice")

func push():
	play("push")
	await Signal(self, "animation_finished")
	play("notice")
