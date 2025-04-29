extends Node

var party = []  # Array of character nodes

func append(character):
	if (party.size() < 4):
		party.append(character)
