extends Node
class_name Character

# Character properties
var character_name: String
var _class: CharacterClass
var stats: Stats
var level: int = 1
var hp: int = 0

var weapon: Weapon
var armor: Armor
var items: Array[Item] = []

# Combat properties
var is_active: bool = false
var position_in_party: int

func _init(set_class: CharacterClass):
	character_name = Util.get_random_name()
	_class = set_class
	stats = set_class.stats
	hp = stats.hp
	
	var gear_rarity_thresholds = {
		Rarity.RarityType.UNCOMMON: 25,
		Rarity.RarityType.RARE: 5,
	}
	
	var starting_weapon = Util.get_choice_by_rarity(
		set_class.starting_weapons,
		gear_rarity_thresholds,
	)
	
	if starting_weapon:
		weapon = LoadoutManager.equipment.weapons[starting_weapon.name]
	
	var starting_armor = Util.get_choice_by_rarity(
		set_class.starting_armor,
		gear_rarity_thresholds,
	)
	
	if starting_armor && starting_armor.name:
		armor = LoadoutManager.equipment.armor[starting_armor.name]

	for item_choices in set_class.starting_items:
		var starting_item = null
		if item_choices:
			var item_choice_roll = randi() % 100
			if item_choice_roll <= item_choices.probability:
				var chosen_item = Util.get_choice_by_rarity(
					item_choices.choices,
					gear_rarity_thresholds,
				)
				if chosen_item:
					starting_item = LoadoutManager.equipment.items[chosen_item.name]
		items.append(starting_item)

func die() -> void:
	# Handle character death
	# Remove from active party
	# Check for game over condition
	pass
