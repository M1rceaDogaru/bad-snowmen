extends Node

var is_two_players := false
var is_turbo := false
var is_running := false

var left_score := 0
var right_score := 0

var was_pressed := false

func _input(event):
	if event is InputEventScreenTouch:
		if not was_pressed and event.is_pressed():
			Input.action_press("interact_p1")
			was_pressed = true
		elif was_pressed and not event.is_pressed():
			Input.action_release("interact_p1")
			was_pressed = false
