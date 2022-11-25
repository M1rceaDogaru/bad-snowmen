extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerRight.is_ai = not GameData.is_two_players
	if GameData.is_turbo:
		Engine.time_scale = 1.2
	else:
		Engine.time_scale = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
