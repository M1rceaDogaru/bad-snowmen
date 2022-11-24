extends KinematicBody2D

var snowball = preload("res://Snowball/Snowball.tscn")

export (String) var action_input = "interact_p1"
export (Vector2) var aim_direction = Vector2.RIGHT
export (int) var jump_speed = -1000
export (int) var gravity = 1500

export (float) var min_jump_height = 500
export (float) var max_jump_height = 1000
export (float) var jump_duration = .5

export (float) var min_throw_distance = 500
export (float) var max_throw_distance = 1000
export (float) var throw_duration = .5

var velocity = Vector2.ZERO
var current_jump_height = 0.0
var current_throw_distance = 0.0

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var on_floor = is_on_floor()
	if Input.is_action_just_pressed(action_input):
		current_jump_height = min_jump_height
		current_throw_distance = min_throw_distance
	
	if Input.is_action_pressed(action_input):
		current_jump_height = clamp(current_jump_height + (max_jump_height - min_jump_height) * delta / jump_duration, min_jump_height, max_jump_height)
		current_throw_distance = clamp(current_throw_distance + (max_throw_distance - min_throw_distance) * delta / throw_duration, min_throw_distance, max_throw_distance)
	
	if Input.is_action_just_released(action_input):
		if on_floor:
			jump()
		else:
			throw_snowball()
			
	velocity = move_and_slide(velocity, Vector2.UP)
		
func jump():
	print(current_jump_height)
	velocity.y = -current_jump_height

func throw_snowball():
	var new_snowball = snowball.instance()
	get_tree().root.add_child(new_snowball)
	new_snowball.player_who_threw = self
	new_snowball.transform.origin = transform.origin + aim_direction
	new_snowball.apply_torque_impulse(rand_range(-10, 10))
	new_snowball.apply_central_impulse(aim_direction * current_throw_distance)
