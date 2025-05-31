extends Area2D


func _on_body_entered(body):
	if body.has_method("armed"):
		body.armed()
		queue_free()
