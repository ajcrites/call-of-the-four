extends Node

var equipment: Dictionary

func _ready():
	load_gear("weapons")
	load_gear("armor")
	load_gear("items")

func load_gear(path: String):
	var dir = DirAccess.open("res://resources/equipment/%s" % [path])
	if not dir:
		push_error("Could not open %s directory!" % [path])
		return
	
	equipment[path] = {}
	
	# List all files in the directory
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			# Load the weapon resource
			var gear_path = "res://resources/equipment/%s/%s" % [path, file_name]
			var gear = load(gear_path)
			if gear:
				equipment[path][gear.get_resource_name()] = gear;
			else:
				push_error("Failed to load gear: " + path + " " + file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
