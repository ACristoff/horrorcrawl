extends Area2D

@onready var grass_deform = $GrassDeform
@onready var animation_player = $AnimationPlayer

var active = false

var look_at

func _on_body_entered(body):
	if body.has_method("step"):
		grass_deform.visible = true
		look_at = body
		active = true
		grass_deform.look_at(body.global_position)
		grass_deform.rotation_degrees -= 180
		grass_deform.frame = 6

func _process(delta):
	if active:
		grass_deform.look_at(look_at.global_position)
		grass_deform.rotation_degrees -= 180

func _on_body_exited(body):
	if body.has_method("step"):
		active = false
		animation_player.play("Return")

func _on_animation_player_animation_finished(anim_name):
	grass_deform.visible = false
