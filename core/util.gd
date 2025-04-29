extends Node

var name_prefixes = [
	"Ael", "Mor", "Thal", "Ka", "Ver", "Syl",
	"And", "Mich", "Car", "El", "Steph", "Jeff", "Bob",
	"Mark", "Kat", "Erdr", "Ke", "Aid",
	"Zan", "Dra", "Tor", "Lan", "Fen", "Ori", "Rha", "Cal", "Jor", "Nym",
	"Sael", "Vek", "Alar", "Ze", "Lor", "Tav", "Myr", "Isil", "Ren", "Hal",
	"Bea", "Ari", "Xan", "Olo", "Gra", "Thra", "Una", "Cor", "Niv", "Luth",
	"Bran", "Vala", "Ryn", "Eld", "Tir", "Nor", "Gor", "Ash", "Yel", "Mal",
	"Kel", "Nara", "Ira", "Sol", "Bryn", "Fay", "Ere", "Tan", "Il", "Ser",
	"Yen", "Orr", "Dro", "Thom", "Za", "Rua", "Nas", "Del", "Om", "Ith",
	"Vel", "Thyr", "Lum", "Eon", "Rek", "Vael", "Quin", "Jal", "Kry", "Nem"
]

var name_suffixes = [
	"ric", "wyn", "dor", "ian", "ael", "eth", "rew",
	"olin", "ly", "anie", "ry", "by", "ick", "ich",
	"ara", "ion", "or", "ien", "las", "mir", "is", "dra", "en", "ius",
	"var", "an", "iel", "ros", "ax", "eth", "ona", "tan", "ys", "thea",
	"mon", "ver", "tor", "ain", "oth", "und", "il", "as", "rel", "bor",
	"rad", "oril", "aneth", "mirra", "ium", "eon", "ias", "oril", "ionne", "etra",
	"elis", "diel", "indor", "amar", "une", "arel", "verin", "adra", "thon", "rith",
	"amos", "ienor", "yth", "aril", "uros", "endra", "omar", "reth", "inis", "alor",
	"ova", "qir", "das", "umir", "lior", "yr", "veth", "ena", "hym", "olas"
]

func get_random_name():
	var pre = name_prefixes.pick_random()
	var suf = " "
	if randi() % 100 > 5:
		suf = name_suffixes.pick_random()
	var vowels = ["a", "e", "i", "o", "u"]
	var sep = ""
	
	if pre[pre.length() - 1] in vowels && suf[0] in vowels:
		sep ="'"
	
	return (pre + sep + suf).strip_edges()

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
