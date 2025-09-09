extends Module

@export var damage : int
var iterations = 0

func ability():
	#apply on attack buffs here
	#for laser apply on hit here as well, for others apply it right before hit
	match iterations:
		0:
			$LaserTop.modulate.a = 255
		1:
			$LaserRight.modulate.a = 255
		2:
			$LaserBottom.modulate.a = 255
		3:
			$LaserLeft.modulate.a = 255
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($LaserLeft, "modulate:a", 0, 0.3)
	tween.tween_property($LaserRight, "modulate:a", 0, 0.3)
	tween.tween_property($LaserTop, "modulate:a", 0, 0.3)
	tween.tween_property($LaserBottom, "modulate:a", 0, 0.3)
	var attacked_enemies = []
	if iterations in [1, 3]:
		for i in range(LevelManager.level.grid_size.x):
			var attacked_space = LevelManager.level.grid[- float(global_position.y / 16)][int(i)]
			if attacked_space != null:
				if iterations == 3 and attacked_space.global_position.x > global_position.x:
					continue
				elif iterations == 1 and attacked_space.global_position.x < global_position.x:
					continue
				if !attacked_space.is_in_group("snake"):
					if attacked_space.has_method("hit") and attacked_space not in attacked_enemies:
						
						attacked_space.hit(damage)
						attacked_enemies.append(attacked_space)
	if iterations in [0, 2]:
		for i in range(LevelManager.level.grid_size.y):
			var attacked_space = LevelManager.level.grid[float(i)][int(global_position.x / 16)]
			if attacked_space != null:
				if iterations == 0 and attacked_space.global_position.y > global_position.y:
					continue
				elif iterations == 2 and attacked_space.global_position.y < global_position.y:
					continue
				if !attacked_space.is_in_group("snake"):
					if attacked_space.has_method("hit") and attacked_space not in attacked_enemies:
						
						attacked_space.hit(damage)
						attacked_enemies.append(attacked_space)
	
	
	await get_tree().create_timer(0.3).timeout
	EventBus.ability_finished.emit()

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	iterations = (iterations + 1) % 4
	$Sprite.rotation_degrees += 90
	InspectManager.add_inspect(self, "BD-L-AM", "Fires a piercing laser. Click the module to rotate", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
	var size = get_tree().get_first_node_in_group("level").grid_size.x if iterations in [1, 3] else get_tree().get_first_node_in_group("level").grid_size.y
	var array = []
	if iterations in [1,3]:
		for i in range(size):
			if i < int(global_position.x / 16) and iterations == 3:
				array.append(Vector2( i, global_position.y / 16))
			elif i > int(global_position.x / 16) and iterations == 1:
				array.append(Vector2( i, global_position.y / 16))
	else:
		for i in range(size):
			if i > -int(global_position.y / 16) and iterations == 0:
				array.append(Vector2(global_position.x / 16, -i))
			elif i < -int(global_position.y / 16) and iterations == 2:
				array.append(Vector2(global_position.x / 16, -i))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	iterations = 0
	attributes = []
