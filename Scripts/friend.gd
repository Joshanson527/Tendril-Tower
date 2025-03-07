extends AnimatedSprite2D

@export var win_area: Area2D

func _ready():
	win_area.area_entered.connect(win)

func win(_area):
	await get_tree().create_timer(randf_range(0, 0.3)).timeout
	play("checkpoint")
	await Signal(self, "animation_finished")
	play("grow")
	await Signal(self, "animation_finished")
	play("idle")
