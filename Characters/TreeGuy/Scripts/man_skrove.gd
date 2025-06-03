extends CharacterBody2D

@onready var body = $MonsterTest
@onready var step = $Step

var speed = 65
var Player : CharacterBody2D

func stepsfx():
	step.play()
	

func _physics_process(delta):
	var target = Player.global_position
	var direction = global_position.direction_to(target)
	velocity = direction * speed
	body.look_at(target)
	body.rotation_degrees -= 90
	move_and_slide()
