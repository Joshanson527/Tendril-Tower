extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 0.1
const DECELERATION = 0.1

@onready var gc := $GrappleController
@onready var sprite := $AnimatedSprite2D

func _physics_process(delta):
	if Input.is_action_pressed("reset"):
		var tree = get_tree()
		if tree:
			tree.reload_current_scene()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("increase_length"):
		gc.rest_length += 5
	elif Input.is_action_just_pressed("decrease_length"):
		gc.rest_length -= 5
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, SPEED * direction, ACCELERATION)
		if direction > 0:
			sprite.animation = "right"
		else:
			sprite.animation = "left"
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)
		sprite.animation = "idle"
	
	if Input.is_action_just_pressed("jump") && (is_on_floor() || gc.launched):
		velocity.y += JUMP_VELOCITY
		gc.retract()
	
	if is_on_floor() and Input.is_action_pressed("down"):
		sprite.animation = "down"
	
	if velocity.y < -10:
		sprite.animation = "up"
	
	move_and_slide()
