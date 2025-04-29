extends Node

func get_choice_by_rarity(choices: Array, rarity_thresholds: Dictionary):
	if !choices || !choices.size():
		return null
	
	var roll = randi() % 100
	
	# Always enforce common selections as a choice
	rarity_thresholds[Rarity.RarityType.COMMON] = 100
	var available_rarities = []
	
	for rarity in rarity_thresholds:
		if roll < rarity_thresholds[rarity]:
			available_rarities.append(rarity)

	var matches = choices.filter(func(c):
		return available_rarities.has(c.selection_rarity)
	)
	if matches.is_empty():
		return null
	return matches.pick_random()
