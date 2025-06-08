extends Control

@onready var slot_scene = preload("res://Data/Inventory/slot.tscn")
@onready var item_scene = preload("res://Data/Inventory/Item.tscn")
@onready var grid_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
@onready var col_count = grid_container.columns

var grid_array = []
var item_held = null
var current_slot = null
var can_place = false
var icon_anchor : Vector2

@export var inventory_size = 180

func _ready():
	for i in range(inventory_size):
		create_slot()
		
func _process(delta):
	if item_held:
		if Input.is_action_just_pressed("left"):
			rotate_item(0)
		if Input.is_action_just_pressed("right"):
			rotate_item(1)
			
		if Input.is_action_just_pressed("left_click"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				place_item()
	else:
		if Input.is_action_just_pressed("left_click"):
			if scroll_container.get_global_rect().has_point(get_global_mouse_position()):
				pick_item()
		
func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_id = grid_array.size()
	new_slot.slot_enter.connect(_on_slot_mouse_enter)
	new_slot.slot_exit.connect(_on_slot_mouse_exit)
	
	grid_container.add_child(new_slot)
	grid_array.push_back(new_slot)
	
func check_slot_available(slot):
	for grid in item_held.item_grids:
		var grid_to_check = slot.slot_id + grid[0] + grid[1] * col_count
		var line_switch_check = slot.slot_id % col_count + grid[0]
		#If it goes past the boundaries
		if line_switch_check < 0 or line_switch_check >= col_count:
			can_place = false
			return
		#If there's not enough space
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			can_place = false
			return
		#If the space is occupied
		if grid_array[grid_to_check].state == grid_array[grid_to_check].States.TAKEN:
			can_place = false
			return
	can_place = true
	
func set_grids(slot):
	for grid in item_held.item_grids:
		var grid_to_check = slot.slot_id + grid[0] + grid[1] * col_count
		var line_switch_check = slot.slot_id % col_count + grid[0]
		if line_switch_check < 0 or line_switch_check >= col_count:
			continue
		if grid_to_check < 0 or grid_to_check >= grid_array.size():
			continue
			
		if can_place:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.FREE)
			if grid[0] < icon_anchor.x:
				icon_anchor.x = grid[0]
			if grid[1] < icon_anchor.y:
				icon_anchor.y = grid[1]
		else:
			grid_array[grid_to_check].set_color(grid_array[grid_to_check].States.TAKEN)
	
func clear_grid():
	for grid in grid_array:
		grid.set_color(grid.States.DEFAULT)
	
func rotate_item(dir):
	item_held.rotate_item(dir)
	clear_grid()
	if current_slot:
		_on_slot_mouse_enter(current_slot)
		
func place_item():
	if not can_place or not current_slot:
		return
		
	var grid_id = current_slot.slot_id + icon_anchor.y * col_count + icon_anchor.x
	item_held.snap_to(grid_array[grid_id].global_position)
	item_held.get_parent().remove_child(item_held)
	grid_container.add_child(item_held)
	item_held.global_position = get_global_mouse_position()
	item_held.grid_anchor = current_slot
	
	for grid in item_held.item_grids:
		var grid_to_check = current_slot.slot_id + grid[0] + grid[1] * col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.TAKEN
		grid_array[grid_to_check].item_stored = item_held
		
	item_held = null
	clear_grid()

func pick_item():
	if not current_slot or not current_slot.item_stored:
		return
	
	item_held = current_slot.item_stored
	item_held.selected = true
	item_held.get_parent().remove_child(item_held)
	add_child(item_held)
	item_held.global_position = get_global_mouse_position()
	
	for grid in item_held.item_grids:
		var grid_to_check = item_held.grid_anchor.slot_id + grid[0] + grid[1] * col_count
		grid_array[grid_to_check].state = grid_array[grid_to_check].States.FREE
		grid_array[grid_to_check].item_stored = null
	
	check_slot_available(current_slot)
	set_grids.call_deferred(current_slot)
	
func _on_slot_mouse_enter(slot):
	icon_anchor = Vector2(1000, 1000)
	current_slot = slot
	if item_held:
		check_slot_available(current_slot)
		set_grids.call_deferred(current_slot)
	slot.set_color(slot.state)
	pass
	
func _on_slot_mouse_exit(slot):
	clear_grid()
	pass

func _on_spawner_pressed():
	var new_item = item_scene.instantiate()
	add_child(new_item)
	
	new_item.load_item(randi_range(1,2))
	new_item.selected = true
	item_held = new_item
