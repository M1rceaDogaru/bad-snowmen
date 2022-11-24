extends Area2D

signal hat_hit(body)

func _on_Hat_body_entered(body):
	if 'Snowball' in body.name:
		emit_signal("hat_hit", body)
