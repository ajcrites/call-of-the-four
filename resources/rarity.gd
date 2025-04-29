extends Resource
class_name Rarity

enum RarityType {
	COMMON,
	UNCOMMON,
	RARE
}

static func get_color(rarity: Rarity) -> Color:
	match rarity:
		RarityType.COMMON:
			return Color(0.8, 0.8, 0.8)  # Light gray
		RarityType.UNCOMMON:
			return Color(0.2, 0.8, 0.2)  # Green
		RarityType.RARE:
			return Color(0.8, 0.2, 0.8)  # Purple
		_:
			return Color.WHITE 
