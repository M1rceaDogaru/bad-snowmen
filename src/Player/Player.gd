extends KinematicBody2D

export (String) var action_input = "interact_p1"
export (int) var jump_speed = -1000
export (int) var gravity = 1500

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var on_floor = is_on_floor()
	if Input.is_action_just_pressed(action_input):
		if on_floor:
			jump()
		else:
			throw_snowball()
			
	velocity = move_and_slide(velocity, Vector2.UP)
			
func jump():
	velocity.y = jump_speed

func throw_snowball():
	pass
