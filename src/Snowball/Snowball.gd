extends RigidBody2D

var player_who_threw : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Snowball_body_entered(body):
	print("it hurts: " + body.name)
	if body == player_who_threw:
		return
		
	queue_free()
