extends Module
var just_shielded = false
var shield_duration = 1
var shield_time = 0

func activate() -> void:
	if current_cooldown <= 0:
		if !manual and activated:
			current_cooldown = cooldown
			ability()
			shield_time = 0
			just_shielded = true
		else:
			await get_tree().create_timer(0.02).timeout
			EventBus.ability_finished.emit()
	else:
		current_cooldown -= 1
		if just_shielded:
			shield_time += 1
		if shield_time == shield_duration and just_shielded:
			remove_shield()
			just_shielded = false
		await get_tree().create_timer(0.02).timeout
		EventBus.ability_finished.emit()

func remove_shield():
	for i in shielded_entites:
		i.guard.queue_free()
		i.has_guard = false
		if "shielded" in i.attributes:
			i.attributes.remove_at(i.attributes.find("shielded"))

var shielded_entites = []
var shield_sprite = preload("res://snake/modules/shield.tscn")
func ability():
	var level = LevelManager.level
	shielded_entites = []
	var pos = level.return_position(global_position)
	for i in [pos.x, pos.x - 1, pos.x + 1]:
		for j in [pos.y + 1.0, pos.y, pos.y - 1.0]:
			if j in [-1.0, 15.0] or i in [-1, 20]:
				continue
			if level.grid[j][i] == null:
				continue
			
			if level.griddd[j][i].is_in_group("head"):
				var guard_instance = shield_sprite.instantiate()
				level.grid[j][i].add_child(guard_instance)
				level.grid[j][i].guard = guard_instance
				level.grid[j][i].has_guard = true
				if "shielded" not in level.grid[j][i].attributes:
					level.grid[j][i].attributes.append("shielded")
				shielded_entites.append(level.grid[j][i])
				continue
			if level.grid[j][i].is_in_group("snake") and !level.grid[j][i].is_in_group("tail"):
				var guard_instance = shield_sprite.instantiate()
				level.grid[j][i].module.add_child(guard_instance)
				level.grid[j][i].module.guard = guard_instance
				level.grid[j][i].module.has_guard = true
				if "shielded" not in level.grid[j][i].module.attributes:
					level.grid[j][i].module.attributes.append("shielded")
				shielded_entites.append(level.grid[j][i].module)
	await get_tree().create_timer(0.1).timeout
	EventBus.ability_finished.emit()

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	InspectManager.add_inspect(self, "BD-S-SN", "Shield all surrounding modules and itself for one turn that blocks damage", {"health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
	var array = []
	for i in [- global_position.y / 16, 1 - global_position.y / 16, -1 - global_position.y / 16]:
		for j in [global_position.x / 16, 1 + global_position.x / 16, -1 + global_position.x / 16]:
			if i >= 0 and j >= 0 and i <= get_tree().get_first_node_in_group("level").grid_size.y - 1 and j <= get_tree().get_first_node_in_group("level").grid_size.x:
				array.append(Vector2i(j, -i))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	attributes = []
