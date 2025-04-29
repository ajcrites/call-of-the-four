extends NamedResource
class_name Weapon

@export var rarity: Rarity.RarityType
@export var power: int

func _init(p_rarity: Rarity.RarityType = Rarity.RarityType.COMMON, p_power = 0):
	rarity = p_rarity
	power = p_power
