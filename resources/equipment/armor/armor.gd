extends NamedResource
class_name Armor

@export var rarity: Rarity.RarityType
@export var absorb: int

func _init(p_rarity: Rarity.RarityType = Rarity.RarityType.COMMON, p_absorb = 0):
	rarity = p_rarity
	absorb = p_absorb
