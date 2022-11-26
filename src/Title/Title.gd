extends Node2D

export (float) var hold_duration = .5

var input_pressed = false
var input_press_duration = 0.0

func _ready():
	var has_touchscreen = OS.has_touchscreen_ui_hint()
	$KeyboardControls.visible = not has_touchscreen
	$TouchControls.visible = has_touchscreen

func _process(delta):
	if Input.is_action_just_pressed("interact_p1"):
		input_pressed = true
		input_press_duration = 0
		
	if Input.is_action_pressed("interact_p1"):
		input_press_duration += delta
		if input_press_duration > hold_duration:
			spin_action()
	
	if Input.is_action_just_released("interact_p1"):
		if input_press_duration > hold_duration:
			take_action()
		else:
			toggle_action()
			
func spin_action():
	if $PlayerSelect.visible:
		if $PlayerSelect/OnePlayerSelector.visible:
			$PlayerSelect/OnePlayerSelector/AnimationPlayer.play("Rotate")
		if $PlayerSelect/TwoPlayerSelector.visible:
			$PlayerSelect/TwoPlayerSelector/AnimationPlayer.play("Rotate")
	elif $SpeedSelect.visible:
		if $SpeedSelect/NormalSelector.visible:
			$SpeedSelect/NormalSelector/AnimationPlayer.play("Rotate")
		if $SpeedSelect/TurboSelector.visible:
			$SpeedSelect/TurboSelector/AnimationPlayer.play("Rotate")
				
func toggle_action():
	if $PlayerSelect.visible:
		GameData.is_two_players = not GameData.is_two_players
		$PlayerSelect/OnePlayerSelector.visible = not GameData.is_two_players
		$PlayerSelect/TwoPlayerSelector.visible = GameData.is_two_players
	elif $SpeedSelect.visible:
		GameData.is_turbo = not GameData.is_turbo
		$SpeedSelect/NormalSelector.visible = not GameData.is_turbo
		$SpeedSelect/TurboSelector.visible = GameData.is_turbo
		
func take_action():
	if $PlayerSelect.visible:
		$PlayerSelect.visible = false
		$SpeedSelect.visible = true
	elif $SpeedSelect.visible:
		get_tree().change_scene("res://Main/Main.tscn")
