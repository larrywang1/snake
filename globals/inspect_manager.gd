extends Node

var is_inspect
var current_inspect
var current_inspected_node

var upgraded_node = preload("res://inspect/upgraded_node.tscn")
var unupgraded_node = preload("res://inspect/unupgraded_node.tscn")
var attribute_node = preload("res://inspect/attribute.tscn")

var open = true

func add_inspect(node : Object, title : String, description : String, stats : Dictionary, activate : bool, activated_state : bool, upgraded : int, unupgraded : int, attributes : Array) -> void:
	if is_inspect:
		remove_inspect()
	
	is_inspect = true
	current_inspect = preload("res://inspect/inspect.tscn").instantiate()
	get_tree().get_first_node_in_group("inspect").add_child(current_inspect)
	open = true
	current_inspected_node = node
	current_inspect.title.text = title
	current_inspect.description.text = description
	var stat_count = 1
	for i in stats:
		var stat_type
		
		match i:
			"attack":
				stat_type = current_inspect.attack
				current_inspect.attack_lbl.text = str(stats[i])
			"health":
				stat_type = current_inspect.health
				current_inspect.health_lbl.text = str(stats[i])
				if node.bonus_health > 0:
					current_inspect.health_lbl.text += "+" + str(node.bonus_health)
			"max_cd":
				stat_type = current_inspect.max_cd
				current_inspect.max_cd_lbl.text = str(stats[i])
			"current_cd":
				stat_type = current_inspect.current_cd
				current_inspect.current_cd_lbl.text = str(stats[i])
			"manual":
				stat_type = current_inspect.manual
				current_inspect.manual_lbl.text = str(stats[i])
			"velocity":
				stat_type = current_inspect.speed
				current_inspect.speed_lbl.text = str(stats[i])
		match stat_count:
			1, 2:
				stat_type.reparent(current_inspect.box_1)
			3, 4:
				stat_type.reparent(current_inspect.box_2)
			5, 6:
				stat_type.reparent(current_inspect.box_3)
		stat_count += 1
	
	if activate and LevelManager.is_in_level:
		current_inspect.button.visible = true
		current_inspect.button.disabled = false
		if activated_state:
			current_inspect.button_label.text = "Activated"
			current_inspect.button.button_pressed = true
			current_inspect.button_label.add_theme_color_override("font_color", Color("03a66b"))
		else:
			current_inspect.button_label.text = "Deactivated"
			current_inspect.button.button_pressed = false
			current_inspect.button_label.remove_theme_color_override("font_color")
	
	for i in range(upgraded):
		var instance = upgraded_node.instantiate()
		current_inspect.upgrade_slot.add_child(instance)
	for i in range(unupgraded):
		var instance = unupgraded_node.instantiate()
		current_inspect.upgrade_slot.add_child(instance)
	
	for i in attributes:
		var attribute = attribute_node.instantiate()
		current_inspect.attributes.add_child(attribute)
		match i:
			"shielded":
				attribute.texture.texture = load("res://art/inspect_symbols/shielded.png")
				attribute.label.text = "Shielded"
			"frozen":
				attribute.texture.texture = load("res://art/inspect_symbols/frozen.png")
				attribute.label.text = "Frozen"
			"cursed":
				attribute.texture.texture = load("res://art/inspect_symbols/cursed.png")
				attribute.label.text = "Cursed"
	
	var upgrade_slots = current_inspect.upgrade_slots
	current_inspect.attributes.remove_child(upgrade_slots)
	current_inspect.attributes.add_child(upgrade_slots)
	
func update_inspect_stat():
	pass

func update_inspect_upgrade():
	pass

func remove_inspect() -> void:
	if is_inspect:
		current_inspect.queue_free()
		is_inspect = false
		get_tree().get_first_node_in_group("green").clear()

func create_tiles(array) -> void:
	for i in array:
		var green = get_tree().get_first_node_in_group("green")
		green.set_cell(i, 0, Vector2i(0, 0))
