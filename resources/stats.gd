extends Resource
class_name Stats

@export var hp: int = 0
@export var strn: int = 0
@export var wis: int = 0

func _init(p_hp: int = 0, p_str: int = 0, p_wis = 0) -> void:
	hp = p_hp
	strn = p_str
	wis = p_wis
