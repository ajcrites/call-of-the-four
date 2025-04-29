extends NamedResource
class_name Item

@export var rarity: Rarity.RarityType
@export var charges: int

func _init(p_rarity: Rarity.RarityType = Rarity.RarityType.COMMON, p_charges = 1):
	rarity = p_rarity
	charges = p_charges
