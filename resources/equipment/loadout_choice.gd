extends Resource
class_name LoadoutChoice

@export var selection_rarity: Rarity.RarityType
@export var name: String

func _init(
	p_rarity: Rarity.RarityType = Rarity.RarityType.COMMON,
	p_name = "",
):
	selection_rarity = p_rarity
	name = p_name
