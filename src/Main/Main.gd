extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()
	
	$PlayerRight.is_ai = not GameData.is_two_players
	if GameData.is_turbo:
		Engine.time_scale = 1.3
	else:
		Engine.time_scale = 1
	
	$GetReady.visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	$GetReady.visible = false
	$JumpAndToss.visible = true
	GameData.is_running = true
	yield(get_tree().create_timer(2.0), "timeout")
	$JumpAndToss.visible = false
	
func update_score():
	$LeftScore.text = str(GameData.left_score)
	$RightScore.text = str(GameData.right_score)

func _process(_delta):
	if not GameData.is_running:
		if $RestartMessage.visible and Input.is_action_just_pressed("interact_p1"):
			get_tree().reload_current_scene()
	else:
		check_end_round()
	
func check_end_round():
	var left = left_lost()
	var right = right_lost()
	if not left and not right:
		return
		
	# someone lost, end game	
	GameData.is_running = false
	if left:
		$EndMessage.text = "RIGHT WINS!"
		GameData.right_score += 1
	else:
		$EndMessage.text = "LEFT WINS!"
		GameData.left_score += 1
		
	update_score()
	$EndMessage.visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	$RestartMessage.visible = true
	
func left_lost():
	return not $PlayerLeft.has_hat and not $PlayerLeft.has_nose
	
func right_lost():
	return not $PlayerRight.has_hat and not $PlayerRight.has_nose
