extends Node

# Party display containers
@onready var party_container = $MarginContainer/VBoxContainer/PartyWrapper/PartyContainer

# UI elements
@onready var reroll_button = $MarginContainer/VBoxContainer/Buttons/Reroll
@onready var start_button = $MarginContainer/VBoxContainer/Buttons/Start
@onready var content = $MarginContainer/VBoxContainer

var class_manager: ClassManager

func _ready():
	class_manager = get_node("/root/ClassManagerNode")
	if not class_manager:
		push_error("ClassManager not found! Make sure it's registered as an autoload.")
		return
	
	generate_starting_party()
	generate_party_display()
	
	reroll_button.pressed.connect(_on_reroll_pressed)
	start_button.pressed.connect(_on_start_pressed)
	
	# Center the content in the window
	center_content()

func center_content():
	# Wait for the next frame to ensure all nodes are properly sized
	await get_tree().process_frame
	
	# Get the window size
	var window_size = get_viewport().get_visible_rect().size
	
	# Calculate the center position
	var content_size = content.size
	var center_x = (window_size.x - content_size.x) / 2
	var center_y = (window_size.y - content_size.y) / 2
	
	# Position the content at the center
	content.position = Vector2(center_x, center_y)

func generate_party_display():
	for child in party_container.get_children():
		child.queue_free()
	
	for i in range(Party.party.size()):
		var character = Party.party[i]
		var character_display = create_character_display(character)
		party_container.add_child(character_display)

func create_character_display(character) -> Control:
	var container = VBoxContainer.new()
	container.custom_minimum_size = Vector2(400, 400)
	
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(400, 400)
	container.add_child(panel)
	
	# Create gradient background based on roles
	var gradient = Gradient.new()
	var colors = []
	
	# Define role colors
	var role_colors = {
		Roles.RoleName.COMBAT: Color(0.8, 0.2, 0.2),  # Red
		Roles.RoleName.SUPPORT: Color(0.2, 0.8, 0.2),  # Green
		Roles.RoleName.UTILITY: Color(0.2, 0.2, 0.8),  # Blue
	}
	
	colors.append(role_colors[character._class.role])
	
	# Create gradient
	gradient.colors = colors
	if colors.size() > 1:
		gradient.offsets = PackedFloat32Array([0.0, 1.0])
	
	# Create gradient texture
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.width = 400
	gradient_texture.height = 400
	
	# Apply gradient to panel
	panel.add_theme_stylebox_override("panel", StyleBoxTexture.new())
	var style = panel.get_theme_stylebox("panel")
	style.texture = gradient_texture
	
	var char_content = VBoxContainer.new()
	char_content.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(char_content)
	
	var name_label = Label.new()
	name_label.add_theme_font_size_override("font_size", 36)
	name_label.text = character.character_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	char_content.add_child(name_label)
	
	var class_label = Label.new()
	class_label.add_theme_font_size_override("font_size", 30)
	class_label.text = character._class.get_resource_name()
	class_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	char_content.add_child(class_label)
	
	if character.weapon:
		var weapon_label = Label.new()
		weapon_label.add_theme_font_size_override("font_size", 20)
		weapon_label.text = character.weapon.get_resource_name()
		weapon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		char_content.add_child(weapon_label)
		
	if character.armor:
		var armor_label = Label.new()
		armor_label.add_theme_font_size_override("font_size", 20)
		armor_label.text = character.armor.get_resource_name()
		armor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		char_content.add_child(armor_label)
		
	if character.items:
		for item in character.items:
			var item_label = Label.new()
			item_label.add_theme_font_size_override("font_size", 20)
			if item:
				item_label.text = item.get_resource_name()
			else:
				item_label.text = "<EMPTY>"
			item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			char_content.add_child(item_label)
	
	var stats_container = VBoxContainer.new()
	stats_container.add_theme_constant_override("separation", 20)
	
	var hp_label = Label.new()
	hp_label.add_theme_font_size_override("font_size", 32)
	hp_label.text = "HP: %d" % [character.stats.hp]
	stats_container.add_child(hp_label)
	
	char_content.add_child(stats_container)
	
	return container

func _on_reroll_pressed():	
	generate_starting_party()
	generate_party_display()
	center_content()

func generate_starting_party():
	# Clear existing party
	Party.party.clear()
	
	# Generate 4 random characters
	var characters = []
	var role_weights = {
		Roles.RoleName.COMBAT: {
			"value": 1,
			"decay": 0.9
		},
		Roles.RoleName.SUPPORT: {
			"value": 0.8,
			"decay": 0.2
		},
		Roles.RoleName.UTILITY: {
			"value": 0.2,
			"decay": 0.1
		},
	}
	var has_combatant = false
		
	while characters.size() < 4:
		# Require at least one combat role
		if (characters.size() == 3 && !has_combatant):
			role_weights = {
				Roles.RoleName.COMBAT: { "value": 1, "decay": 1},
				Roles.RoleName.SUPPORT: { "value": 0, "decay": 0},
				Roles.RoleName.UTILITY: { "value": 0, "decay": 0},
			}
		var chosen_class = class_manager.get_random_class(role_weights)
		if (chosen_class):
			var role = chosen_class.role
			if (role == Roles.RoleName.COMBAT):
				has_combatant = true
			role_weights[role].value *= role_weights[role].decay
			characters.append(Character.new(chosen_class))
	
	# Sort characters by role and priority
	characters.sort_custom(func(a, b):
		# First sort by role - combat roles always come first
		var a_is_combat = Roles.RoleName.COMBAT == a._class.role
		var b_is_combat = Roles.RoleName.COMBAT == b._class.role
		if a_is_combat != b_is_combat:
			return a_is_combat
		
		# If roles are the same, sort by priority
		return a._class.priority < b._class.priority
	)
	
	# Add sorted characters to party
	for character in characters:
		Party.append(character)

func _on_start_pressed():
	pass
