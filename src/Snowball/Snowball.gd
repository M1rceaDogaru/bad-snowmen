extends RigidBody2D

var player_who_threw : Node
var has_collided = false

func _process(delta):
	if has_collided and $Blast.emitting == false:
		queue_free()

func _on_Snowball_body_entered(body):
	print("it hurts: " + body.name)
	if body == player_who_threw:
		return
	
	call_deferred("stop_snowball")

func stop_snowball():
	mode = RigidBody2D.MODE_STATIC
	$CollisionShape2D.disabled = true
	$Blast.restart()
	has_collided = true
