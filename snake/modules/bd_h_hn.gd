extends Module
var just_health = false
var health_duration = 2
var health_time = 0
var health_strength = 2

func activate() -> void:
	if current_cooldown <= 0:
		if !manual and activated:
			remove_health()
			current_cooldown = cooldown
			ability()
			health_time = 0
			just_health = true
		else:
			await get_tree().create_timer(0.02).timeout
			EventBus.ability_finished.emit()
	else:
		current_cooldown -= 1
		if just_health:
			health_time += 1
		if health_time == health_duration and just_health:
			remove_health()
			just_health = false
		await get_tree().create_timer(0.02).timeout
		EventBus.ability_finished.emit()

func remove_health():
	for i in shielded_entites:
		if i.bonus_health >= health_strength:
			i.bonus_health -= health_strength
		else:
			i.bonus_health = 0

var shielded_entites = []
func ability():
	var level = LevelManager.level
	shielded_entites = []
	var pos = level.return_position(global_position)
	for i in [pos.x, pos.x - 1, pos.x + 1]:
		for j in [pos.y + 1.0, pos.y, pos.y - 1.0]:
			if j in [-1.0, 15.0] or i in [-1.0, 20.0]:
				continue

			if level.grid[j][i] == null:
				continue
			
			if level.grid[j][i].is_in_group("head"):
				level.grid[j][i].bonus_health += health_strength
				shielded_entites.append(level.grid[j][i])
				continue
			if level.grid[j][i].is_in_group("snake") and !level.grid[j][i].is_in_group("tail"):
				level.grid[j][i].module.bonus_health += health_strength
				shielded_entites.append(level.grid[j][i].module)
	await get_tree().create_timer(0.05).timeout
	EventBus.ability_finished.emit()

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	InspectManager.add_inspect(self, "BD-H-HN", "Add bonus health to all surrounding modules and itself for one turn", {"attack" : health_strength,"health": health,  "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
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
