extends Node
class_name ClassManager

var classes: Array[CharacterClass] = []

func _ready() -> void:
	# Load all character class resources
	var dir = DirAccess.open("res://resources/classes/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var resource = load("res://resources/classes/" + file_name)
				if resource is CharacterClass:
					classes.append(resource)
			file_name = dir.get_next()

func get_random_class(role_weights: Dictionary) -> CharacterClass:
	if classes.is_empty():
		return null
	
	var total_weight = 0
	for weight in role_weights.values():
		total_weight += weight.value
		
	var cumulative = 0
	
	var selected_role: Roles.RoleName = Roles.RoleName.COMBAT
	var role_roll = randf() * total_weight
			
	for role in role_weights.keys():
		cumulative += role_weights[role].value
		if role_roll <= cumulative:
			selected_role = role
			break
	
	var c = Util.get_choice_by_rarity(
		classes.filter(func(r): return r.role == selected_role),
		{
			Rarity.RarityType.UNCOMMON: 15,
			Rarity.RarityType.RARE: 4,
		}
	)
	
	return c
