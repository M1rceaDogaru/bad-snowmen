extends RigidBody2D

var player_who_threw : Node

func _on_Snowball_body_entered(body):
	print("it hurts: " + body.name)
	if body == player_who_threw:
		return
		
	queue_free()
