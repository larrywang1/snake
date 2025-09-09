extends Module

@export var damage : int
var top = true

func ability():
	#apply on attack buffs here
	#for laser apply on hit here as well, for others apply it right before hit
	if top:
		$LaserTop.modulate.a = 255
	else:
		$LaserBottom.modulate.a = 255
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($LaserTop, "modulate:a", 0, 0.3)
	tween.tween_property($LaserBottom, "modulate:a", 0, 0.3)
	var attacked_enemies = []
	for i in range(LevelManager.level.grid_size.y):
		var attacked_space = LevelManager.level.grid[float(i)][int(global_position.x / 16)]
		if attacked_space != null:
			if top and attacked_space.global_position.y > global_position.y:
				continue
			elif !top and attacked_space.global_position.y < global_position.y:
				continue
			if !attacked_space.is_in_group("snake"):
				if attacked_space.has_method("hit") and attacked_space not in attacked_enemies:
					
					attacked_space.hit(damage)
					attacked_enemies.append(attacked_space)
	top = !top
	
	await get_tree().create_timer(0.3).timeout
	EventBus.ability_finished.emit()
	$Sprite.rotation_degrees += 180

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	InspectManager.add_inspect(self, "BD-L-TBA", "Fires an alternating piercing laser upwards and downwards", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
	var size = get_tree().get_first_node_in_group("level").grid_size.x
	var array = []
	for i in range(size):
		if i > -int(global_position.y / 16) and top:
			array.append(Vector2(global_position.x / 16, -i))
		elif i < -int(global_position.y / 16) and !top:
			array.append(Vector2(global_position.x / 16, -i))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	top = true
	$Sprite.rotation_degrees = 0
	attributes = []
