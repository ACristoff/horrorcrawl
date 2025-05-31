extends CharacterBody2D

var speed = 50
@onready var body = $Body
@onready var movement = $Movement


func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if velocity:
		movement.play("Walk")
	else:
		movement.play("Idle")
	velocity = direction * speed
	body.look_at(get_global_mouse_position())
	body.rotation_degrees -= 90

	move_and_slide()
