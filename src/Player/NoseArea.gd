extends Area2D

signal nose_hit(body)

func _on_Nose_body_entered(body):
	if 'Snowball' in body.name:
		emit_signal("nose_hit", body)
