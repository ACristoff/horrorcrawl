extends CharacterBody2D

var speed = 80
@onready var body = $Body
@onready var movement = $Movement
@onready var arms = $Arms
@onready var silenced_pistol_held = $Body/SilencedPistolHeld
@onready var SFXLIFT = preload("res://Characters/BimboGirl/grass_lift.tscn")
@onready var SFXSTEP = preload("res://Characters/BimboGirl/grass_step.tscn")
@onready var ENEMY = preload("res://Characters/TreeGuy/man_skrove.tscn")

@onready var path_2d = $Path2D
@onready var enemy_spawn = $Path2D/EnemySpawn

var is_armed = false
func armed():
	is_armed = true
	silenced_pistol_held.visible = true
	
func step():
	var sfxs = SFXSTEP.instantiate()
	add_child(sfxs)

func spawn_enemy():
	enemy_spawn.progress_ratio = randf_range(0, 1)
	var enemy = ENEMY.instantiate()
	get_tree().get_root().add_child(enemy)
	enemy.global_position = enemy_spawn.global_position
	enemy.Player = self
	
func lift():
	var sfxl = SFXLIFT.instantiate()
	add_child(sfxl)

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


func _on_spawn_enemy_timeout():
	spawn_enemy()
