extends Node2D

@onready var IconRect = $Icon

var item_id : int
var item_grids = []
var selected = false
var grid_anchor = null

func _ready():
	pass
	
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		pass
	pass
	
func load_item(id : int):
	var icon_path = InventoryHandler.get_item(id)["Icon"]
	IconRect.texture = load(icon_path)
	
	for grid in InventoryHandler.item_grid_data[str(id)]:
		var converter_array = []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)

func rotate_item(dir):
	for grid in item_grids:
		var temp_x = grid[0]
		var temp_y = grid[1]
		#Left
		if dir == 0:
			grid[1] = -grid[0]
			grid[0] = temp_y
		#Right
		if dir == 1:
			grid[0] = -grid[1]
			grid[1] = temp_x
	#Left
	if dir == 0:
		rotation_degrees -= 90
	#Right
	if dir == 1:
		rotation_degrees += 90
	if rotation_degrees >= 360 or rotation_degrees <= -360:
		rotation_degrees = 0

func snap_to(destination : Vector2):
	var tween = get_tree().create_tween()
	if int(rotation_degrees) % 180 == 0:
		destination += IconRect.size/2
	else:
		var temp_xy = Vector2(IconRect.size.y, IconRect.size.x)
		destination += temp_xy/2
		
	tween.tween_property(self, "global_position", destination, 0.15).set_trans(Tween.TRANS_SINE)
	
	selected = false
