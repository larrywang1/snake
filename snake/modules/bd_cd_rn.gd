extends Module


var strength = 1


func ability():
	var level = LevelManager.level
	var pos = level.return_position(global_position)
	for i in [pos.x, pos.x - 1, pos.x + 1]:
		for j in [pos.y + 1.0, pos.y, pos.y - 1.0]:
			if j in [-1.0, 15.0] or i in [-1, 20]:
				continue
			if level.grid[j][i] == null or level.grid[j][i] == self:
				continue
			
			if level.grid[j][i].is_in_group("head"):
				level.grid[j][i].current_cooldown -= strength
				continue
			if level.grid[j][i].is_in_group("snake") and !level.grid[j][i].is_in_group("tail") and level.grid[j][i].module:

				level.grid[j][i].module.current_cooldown -= strength
	await get_tree().create_timer(0.05).timeout
	EventBus.ability_finished.emit()

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	InspectManager.add_inspect(self, "BD-CD-RN", "Reduce the cooldown of all surrounding modules", {"attack" : strength,"health": health,  "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
	var array = []
	for i in [- global_position.y / 16, 1 - global_position.y / 16, -1 - global_position.y / 16]:
		for j in [global_position.x / 16, 1 + global_position.x / 16, -1 + global_position.x / 16]:
			if i >= 0 and j >= 0 and i <= get_tree().get_first_node_in_group("level").grid_size.y - 1 and j <= get_tree().get_first_node_in_group("level").grid_size.x and Vector2(i, j) != Vector2(- global_position.y / 16,global_position.x / 16):
				array.append(Vector2i(j, -i))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	attributes = []
