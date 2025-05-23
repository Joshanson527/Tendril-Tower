extends CharacterBody2D

signal respawn()
signal win()

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -200.0
const ACCELERATION: float = 0.1
const DECELERATION: float = 0.1

@onready var gc := $GrappleController
@onready var sprite := $AnimatedSprite2D
@onready var health := $Health
@onready var camera := $Camera2D
@onready var level: Node2D = $"../Level"

@export var rotation_speed: float = 10.0

var win_area: Area2D
var time: Label
var deaths: Label
var checkpoints: Array[AnimatedSprite2D]
var current_checkpoint: int = 0

var animation_override: bool = false
@export var control_override: bool = false

var will_die: bool = false
var god_mode: bool = false

var death_count: int = 0

@export var friction: float = 1.0

var level_ready: bool = false

func _ready():
	while level == null:
		pass
	
	init()

func init():
	win_area = level.win_area
	time = level.time_counter
	deaths = level.death_counter
	checkpoints = level.checkpoints
	
	win_area.area_entered.connect(_on_win_area_entered)
	
	level_ready = true

func _process(_delta):
	if !level_ready:
		return
	
	deaths.text = "Deaths: " + str(death_count)
	
	var closest_distance: float = 999.0
	var closest_checkpoint
	for checkpoint in checkpoints:
		var pos1 = self.global_position
		var pos2 = checkpoint.global_position
		var distance = sqrt((pos2.x - pos1.x) ** 2 + (pos2.y - pos1.y) ** 2)
		if distance < closest_distance: 
			closest_distance = distance
			closest_checkpoint = checkpoints.find(checkpoint, 0)

	if closest_distance <= 15 and !checkpoints[closest_checkpoint].unlocked:
		checkpoints[closest_checkpoint].unlock()
		if closest_checkpoint > current_checkpoint:
			current_checkpoint = closest_checkpoint

func _physics_process(delta):
	if !level_ready:
		return
	
	if Input.is_action_pressed("reset") and !control_override:
		health.kill()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif will_die and !god_mode:
		health.kill()
	
	if (Input.is_action_just_pressed("increase_length") or Input.is_action_pressed("increase_length_key")) and gc.rest_length < 30 and !control_override:
		gc.rest_length += 1
	elif (Input.is_action_just_pressed("decrease_length") or Input.is_action_pressed("decrease_length_key")) and gc.rest_length > 5 and !control_override:
		gc.rest_length -= 1
	
	var move_direction = Input.get_axis("left", "right")
	if move_direction and !control_override:
		velocity.x = lerp(velocity.x, SPEED * move_direction, ACCELERATION)
		if !animation_override:
			if move_direction > 0:
				sprite.play("right")
			else:
				sprite.play("left")
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)
		if is_on_floor() and !animation_override:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			sprite.play("idle")
	
	if Input.is_action_pressed("jump") and (is_on_floor() || gc.launched) and !control_override:
		velocity.y += JUMP_VELOCITY
		gc.retract()
	
	if is_on_floor() and Input.is_action_pressed("down") and !animation_override and !control_override:
		sprite.play("down")
	
	if velocity.y < -10 and !animation_override:
		sprite.play("up")
	
	if gc.launched:
		var target_pos = gc.target
		var direction = (target_pos - global_position).normalized()
		var target_ang = direction.angle() + deg_to_rad(90)
		rotation = lerp_angle(rotation, target_ang, rotation_speed * delta)
	else:
		rotation_degrees = move_toward(rotation_degrees, 0, 100 * delta)
	
	if velocity.y > 500 and !control_override:
		will_die = true
	else:
		will_die = false
	
	move_and_slide()

func _on_health_died(_entity):
	animation_override = true
	control_override = true
	
	death_count += 1
	health.current = 1
	
	sprite.play("hit")
	await get_tree().create_timer(0.25).timeout
	
	sprite.play("die")
	await get_tree().create_timer(1).timeout # Wait for death animation to finish
	
	camera.position_smoothing_enabled = false
	
	emit_signal("respawn")
	await get_tree().create_timer(1).timeout # Wait for fade out to happen
	
	position = checkpoints[current_checkpoint].position
	sprite.play("grow")
	sprite.pause()

func _on_transition_respawn_fade():
	sprite.play()
	
	await get_tree().create_timer(0.8).timeout
	
	camera.position_smoothing_enabled = true
	
	animation_override = false
	control_override = false

func _on_win_area_entered(_area):
	control_override = true
	animation_override = true
	emit_signal("win")
	sprite.play("left")
	sprite.pause()
	await get_tree().create_timer(0.5).timeout
	sprite.play("right")
	sprite.pause()
	await get_tree().create_timer(0.5).timeout
	sprite.play("idle")
