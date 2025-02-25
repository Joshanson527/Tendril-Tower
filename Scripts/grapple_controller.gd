extends Node2D

@export var rest_length = 20.0
@export var stiffness = 75.0
@export var damping = 10.0

@onready var player := get_parent()
@onready var ray := $RayCast2D
@onready var rope := $Line2D
@onready var crosshair := $"../Crosshair"

@export var launched = false
@export var target: Vector2

var grapple_override = false

func _process(delta):
	grapple_override = player.control_override
	
	if grapple_override:
		retract()
	
	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("grapple") and !grapple_override:
		launch()
	if Input.is_action_just_released("grapple"):
		retract()
	
	if launched:
		set_crosshair(target, true)
		handle_grapple(delta)
	else:
		if ray.is_colliding():
			set_crosshair(ray.get_collision_point(), true)
		else:
			target = position
			target.x += 100
			set_crosshair(target, false)

func launch():
	if ray.is_colliding():
		rest_length = 20.0
		launched = true
		target = ray.get_collision_point()
		rope.show()

func retract():
	launched = false
	rope.hide()

func handle_grapple(delta):
	var target_dir = player.global_position.direction_to(target)
	var target_dist = player.global_position.distance_to(target)
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force + damping
	
	player.velocity += force * delta
	update_rope()

func update_rope():
	rope.set_point_position(1, to_local(target))

func set_crosshair(crosshair_target: Vector2, visibility: bool):
	crosshair.position = to_local(crosshair_target)
	if visibility:
		crosshair.show()
	else:
		crosshair.hide()
