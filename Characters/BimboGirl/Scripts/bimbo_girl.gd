extends CharacterBody2D

var speed = 80
@onready var body = $Body
@onready var movement = $Movement
@onready var arms = $Arms
@onready var silenced_pistol_held = $Body/SilencedPistolHeld
@onready var step_sfx = preload("res://Characters/BimboGirl/Assets/sfx_step_sand_l.mp3")

var is_armed = false
func armed():
	is_armed = true
	silenced_pistol_held.visible = true
	
func step():
	AudMan.play_sfx(step_sfx)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if velocity:
		movement.play("Walk")
		if is_armed:
			armed()
			arms.play("ArmedWalk")
		else:
			arms.play("UnarmedWalk")
	else:
		silenced_pistol_held.visible = false
		movement.play("Idle")
		arms.play("Idle")
	velocity = direction * speed
	body.look_at(get_global_mouse_position())
	body.rotation_degrees -= 90

	move_and_slide()
