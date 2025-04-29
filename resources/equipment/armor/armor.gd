extends NamedResource
class_name Armor

@export var rarity: Rarity.RarityType
@export var absorb: int
@export var type: ArmorCategories.ArmorType
@export var wearers: Array[String]

func _init(
	p_rarity: Rarity.RarityType = Rarity.RarityType.COMMON,
	p_absorb = 0,
	p_type = ArmorCategories.ArmorType.NONE,
	p_wearers: Array[String] = []
):
	rarity = p_rarity
	absorb = p_absorb
	type = p_type
	wearers = p_wearers
