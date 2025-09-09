extends Module
@export var damage : int
var side = 0
var burst_number = 2

func ability():
	#apply on attack buffs here
	#for laser apply on hit here as well, for others apply it right before hit
	match side:
		0:
			$LaserTop.modulate.a = 255
			$LaserBottom.modulate.a = 255
		1:
			$LaserRight.modulate.a = 255
			$LaserLeft.modulate.a = 255

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($LaserLeft, "modulate:a", 0, 0.3)
	tween.tween_property($LaserRight, "modulate:a", 0, 0.3)
	tween.tween_property($LaserTop, "modulate:a", 0, 0.3)
	tween.tween_property($LaserBottom, "modulate:a", 0, 0.3)
	var attacked_enemies = []
	if side == 1:
		for i in range(LevelManager.level.grid_size.x):
			var attacked_space = LevelManager.level.grid[- float(global_position.y / 16)][int(i)]
			if attacked_space != null:
				if !attacked_space.is_in_group("snake"):
					if attacked_space.has_method("hit") and attacked_space not in attacked_enemies:
						
						attacked_space.hit(damage)
						attacked_enemies.append(attacked_space)
	if side == 0:
		for i in range(LevelManager.level.grid_size.y):
			var attacked_space = LevelManager.level.grid[float(i)][int(global_position.x / 16)]
			if attacked_space != null:
				
				if !attacked_space.is_in_group("snake"):
					if attacked_space.has_method("hit") and attacked_space not in attacked_enemies:
						
						attacked_space.hit(damage)
						attacked_enemies.append(attacked_space)
	
	await get_tree().create_timer(0.3).timeout
	EventBus.ability_finished.emit()
	if burst_number > 0:
		current_cooldown = 0
		burst_number -= 1
	else:
		current_cooldown = cooldown
		burst_number = 2
func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	match side:
		0:
			InspectManager.add_inspect(self, "BD-L-TAS", "Fires a burst of 3 lasers vertically", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
		1:
			InspectManager.add_inspect(self, "BD-L-TAS", "Fires a burst of 3 lasers horizontally", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
		
	var size = get_tree().get_first_node_in_group("level").grid_size.x if side in [1, 3] else get_tree().get_first_node_in_group("level").grid_size.y
	var array = []
	if side == 1:
		for i in range(size):
			if i != int(global_position.x / 16):
				array.append(Vector2( i, global_position.y / 16))

	else:
		for i in range(size):
			if i != -int(global_position.y / 16):
				array.append(Vector2(global_position.x / 16, -i))

	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	randomize_side() #move this to only randomize on generate in shop
	attributes = []
	
func randomize_side():
	side = randi_range(0, 1)
	match side:
		1:
			$Sprite.rotation_degrees = 90
