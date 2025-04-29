extends NamedResource
class_name Weapon

@export var rarity: Rarity.RarityType
@export var power: int
@export var type: WeaponCategories.WeaponType
@export var holders: Array[String]

func _init(
	p_rarity: Rarity.RarityType = Rarity.RarityType.COMMON,
	p_power = 0,
	p_type = WeaponCategories.WeaponType.NONE,
	p_holders: Array[String] = [] 
):
	rarity = p_rarity
	power = p_power
	type = p_type
	holders = p_holders
