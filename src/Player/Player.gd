extends KinematicBody2D

var snowball = preload("res://Snowball/Snowball.tscn")
var hat = preload("res://Player/Hat.tscn")
var nose = preload("res://Player/Nose.tscn")

export (String) var action_input = "interact_p1"
export (Vector2) var aim_direction = Vector2.RIGHT
export (int) var jump_speed = -1000
export (int) var gravity = 1500

export (float) var min_jump_height = 500.0
export (float) var max_jump_height = 1000.0
export (float) var jump_duration = .5

export (float) var min_throw_distance = 500.0
export (float) var max_throw_distance = 1000.0
export (float) var throw_duration = .5

export (bool) var is_ai = false
export (float) var ai_input_wait_min = 0.05
export (float) var ai_input_wait_max = 0.3

var has_hat = true
var has_nose = true

var velocity = Vector2.ZERO
var current_jump_height = 0.0
var current_throw_distance = 0.0

var ai_input_wait = 0.0
var ai_current_input_wait = 0.0

func _ready():
	set_scale(Vector2(aim_direction.x, 1))
	
func _process(delta):
	if not GameData.is_running or not is_ai:
		return
	do_ai_stuff(delta)	
	
func do_ai_stuff(delta):
	ai_current_input_wait += delta
	if ai_current_input_wait > ai_input_wait:
		ai_input_wait = rand_range(ai_input_wait_min, ai_input_wait_max)
		ai_current_input_wait = 0.0
		if Input.is_action_pressed(action_input):
			Input.action_release(action_input)
		else:
			Input.action_press(action_input)

func _physics_process(delta):
	if not GameData.is_running:
		return
		
	velocity.y += gravity * delta
	
	var on_floor = is_on_floor()
	var input_is_pressed = Input.is_action_pressed(action_input)
	if Input.is_action_just_pressed(action_input):
		current_jump_height = min_jump_height
		current_throw_distance = min_throw_distance
		if on_floor:
			$AnimationPlayer.play("Jump")
	
	if input_is_pressed:
		current_jump_height = clamp(current_jump_height + (max_jump_height - min_jump_height) * delta / jump_duration, min_jump_height, max_jump_height)
		current_throw_distance = clamp(current_throw_distance + (max_throw_distance - min_throw_distance) * delta / throw_duration, min_throw_distance, max_throw_distance)
	
	if Input.is_action_just_released(action_input):
		if on_floor:
			jump()
		else:
			throw_snowball()
			
	velocity = move_and_slide(velocity, Vector2.UP)
		
func jump():
	$JumpSound.play()
	$AnimationPlayer.play_backwards("Jump")
	velocity.y = -current_jump_height

func throw_snowball():
	var new_snowball = snowball.instance()
	get_tree().root.add_child(new_snowball)
	new_snowball.player_who_threw = self
	new_snowball.transform.origin = transform.origin + aim_direction
	new_snowball.apply_torque_impulse(rand_range(-10, 10))
	new_snowball.apply_central_impulse(aim_direction * current_throw_distance)
	$AnimationPlayer.play("Toss")
	$ThrowSound.play()

func _on_hat_hit(body):
	if body.player_who_threw == self:
		return
	call_deferred("hit_the_hat")
	
func hit_the_hat():
	$Hat/CollisionShape2D.disabled = true
	$Hat.visible = false
	var new_hat = hat.instance()
	get_tree().root.add_child(new_hat)
	new_hat.transform.origin = $Hat.global_transform.origin
	new_hat.global_rotation_degrees = $Hat.global_rotation_degrees
	has_hat = false

func _on_nose_hit(body):
	if body.player_who_threw == self:
		return
	call_deferred("hit_the_nose")
	
func hit_the_nose():
	$Nose/CollisionShape2D.disabled = true
	$Nose.visible = false
	var new_nose = nose.instance()
	get_tree().root.add_child(new_nose)
	new_nose.transform.origin = $Nose.global_transform.origin
	new_nose.global_rotation_degrees = $Nose.global_rotation_degrees
	has_nose = false
