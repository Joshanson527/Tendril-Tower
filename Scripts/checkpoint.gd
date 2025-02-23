extends AnimatedSprite2D

@export var unlocked: bool = false

func _ready():
	play("pot")

func unlock():
	play("checkpoint")
	unlocked = true
