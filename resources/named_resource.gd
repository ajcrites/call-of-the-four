extends Resource
class_name NamedResource

var description = ""

func get_resource_name() -> String:
	var path = resource_path
	if path.is_empty():
		return ""
	
	var filename = path.get_file().get_basename()
	
	var words = filename.split("_")
	for i in words.size():
		words[i] = words[i].capitalize()
	
	return " ".join(words)
