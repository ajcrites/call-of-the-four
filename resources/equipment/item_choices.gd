extends Resource
class_name ItemChoices

@export var choices: Array[LoadoutChoice]
# Chance that this item slot will be filled
@export var probability: int = 100

func _init(p_choices: Array[LoadoutChoice] = [], p_probability = 100):
	choices = p_choices
	probability = p_probability
