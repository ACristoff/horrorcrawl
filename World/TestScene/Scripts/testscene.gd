extends Node2D

@onready var GRASS = preload("res://World/TestScene/grass_defo.tscn")

func _ready():
	pass
	for i in range(2000):
		var grass = GRASS.instantiate()
		add_child(grass)
		grass.position.x = randi_range(0, 100)
		grass.position.y = randi_range(0, 100)
