extends Node

# Game state
enum GameState {
	PARTY_GENERATION,
	PLAYER_TURN,
	ENEMY_TURN,
	MENU_OPEN,
	GAME_OVER
}

var current_state = GameState.PARTY_GENERATION
var current_character_index = 0  # Which character is currently acting
var current_scene: Node = null

func _ready():
	# Start with party generation
	call_deferred("load_party_generation")

func load_party_generation():
	# Load the party generation scene
	var party_gen_scene = load("res://scenes/party_gen.tscn")
	if party_gen_scene:
		var party_gen_instance = party_gen_scene.instantiate()
		add_child(party_gen_instance)
	else:
		# Handle error case
		pass

func start_game():
	pass

func start_player_turn():
	current_state = GameState.PLAYER_TURN
	current_character_index = 0
	# Enable input for the first character in the party

func enable_character_input(_character):
	# Signal that it's this character's turn
	# This will enable player input and actions for this specific character
	pass

func next_character_turn():
	current_character_index += 1

func start_enemy_turn():
	current_state = GameState.ENEMY_TURN
	# Process enemy actions
	# After all enemies have acted, return to player turn
	start_player_turn()

func open_menu():
	current_state = GameState.MENU_OPEN
	# Pause game actions while menu is open

func close_menu():
	# Return to previous state (usually player turn)
	current_state = GameState.PLAYER_TURN

func game_over():
	current_state = GameState.GAME_OVER
	# Handle game over logic 
