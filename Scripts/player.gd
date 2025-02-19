extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 0.1
const DECELERATION = 0.1

@onready var gc := $GrappleController
@onready var sprite := $AnimatedSprite2D

@export var rotation_speed: float = 10.0

func _physics_process(delta):
	if Input.is_action_pressed("reset"):
		var tree = get_tree()
		if tree:
			tree.reload_current_scene()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if (Input.is_action_just_pressed("increase_length") || Input.is_action_pressed("increase_length_key")) && gc.rest_length < 80:
		gc.rest_length += 3
	elif (Input.is_action_just_pressed("decrease_length") || Input.is_action_pressed("decrease_length_key")) && gc.rest_length > 20:
		gc.rest_length -= 3
	
	var move_direction = Input.get_axis("left", "right")
	if move_direction:
		velocity.x = lerp(velocity.x, SPEED * move_direction, ACCELERATION)
		if move_direction > 0:
			sprite.play("right")
		else:
			sprite.play("left")
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)
		if is_on_floor():
			sprite.play("idle")
	
	if Input.is_action_just_pressed("jump") && (is_on_floor() || gc.launched):
		velocity.y += JUMP_VELOCITY
		gc.retract()
	
	if is_on_floor() and Input.is_action_pressed("down"):
		sprite.play("down")
	
	if velocity.y < -10:
		sprite.play("up")
	
	if gc.launched:
		var target_pos = gc.target
		var direction = (target_pos - global_position).normalized()
		var target_ang = direction.angle() + deg_to_rad(90)
		rotation = lerp_angle(rotation, target_ang, rotation_speed * delta)
	else:
		rotation_degrees = move_toward(rotation_degrees, 0, 100 * delta)
	
	move_and_slide()
