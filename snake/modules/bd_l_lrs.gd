extends Module

@export var damage : int


func ability():
	#apply on attack buffs here
	#for laser apply on hit here as well, for others apply it right before hit
	$LaserLeft.modulate.a = 255
	$LaserRight.modulate.a = 255
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($LaserLeft, "modulate:a", 0, 0.3)
	tween.tween_property($LaserRight, "modulate:a", 0, 0.3)
	var attacked_enemies = []
	for i in range(LevelManager.level.grid_size.x):
		var attacked_space = LevelManager.level.grid[- float(global_position.y / 16)][int(i)]
		if attacked_space != null:
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
	InspectManager.add_inspect(self, "BD-L-LRS", "Fires a piercing laser leftwards and rightwards simultaneously", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
	var size = get_tree().get_first_node_in_group("level").grid_size.x
	var array = []
	for i in range(size):
		if i != int(global_position.x / 16):
			array.append(Vector2( i, global_position.y / 16))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	attributes = []
