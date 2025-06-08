extends Node

@onready var item_data_path = "res://Data/Inventory/item_data.json"
var item_data = {}
var item_grid_data = {}

func _ready():
	load_data(item_data_path)
	set_grid_data()
	pass
	
func _process(delta):
	pass
	
func load_data(path):
	if not FileAccess.file_exists(path):
		print("Item data not found")
		return
	var item_data_file = FileAccess.open(path, FileAccess.READ)
	item_data = JSON.parse_string(item_data_file.get_as_text())
	item_data_file.close()
	
	#print(item_data)
	pass
	
func set_grid_data():
	for item in item_data.keys():
		var temp_grid_array = []
		for point in item_data[item]["Grid"].split("/"):
			temp_grid_array.push_back(point.split(","))
		item_grid_data[item] = temp_grid_array
	
	pass

func get_item(id) -> Dictionary:
	var item = null
	item = item_data[str(id)]
	
	return item
	pass
