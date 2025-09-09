extends Module

@export var damage : int
var side = 0
var bullet_scene = preload("res://snake/modules/bullet.tscn")

func ability():
	#apply on attack buffs here
	#for laser apply on hit here as well, for others apply it right before hit
	var bullet = bullet_scene.instantiate()
	bullet.large = false
	bullet.damage = damage
	bullet.global_position = global_position
	match side:
		0:
			bullet.direction = "up"
		1:
			bullet.direction = "right"
		2:
			bullet.direction = "down"
		3:
			bullet.direction = "left"
	get_tree().get_first_node_in_group("projectiles").add_child(bullet)
	bullet.move()
	bullet = bullet_scene.instantiate()
	bullet.large = true
	bullet.damage = damage
	bullet.global_position = global_position
	match side:
		0:
			bullet.direction = "up"
		1:
			bullet.direction = "right"
		2:
			bullet.direction = "down"
		3:
			bullet.direction = "left"
	get_tree().get_first_node_in_group("projectiles").add_child(bullet)
	bullet.move()
	await get_tree().create_timer(0.2).timeout
	EventBus.ability_finished.emit()

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	match side:
		0:
			InspectManager.add_inspect(self, "BD-B-DA", "Fires two bullet of different speeds upwards", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
		1:
			InspectManager.add_inspect(self, "BD-B-DA", "Fires two bullet of different speeds rightwards", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
		2:
			InspectManager.add_inspect(self, "BD-B-DA", "Fires two bullet of different speeds downwards", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
		3:
			InspectManager.add_inspect(self, "BD-B-DA", "Fires two bullet of different speeds leftwards", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
	var size = get_tree().get_first_node_in_group("level").grid_size.x if side in [1, 3] else get_tree().get_first_node_in_group("level").grid_size.y
	var array = []
	if side in [1,3]:
		for i in range(size):
			if i < int(global_position.x / 16) and side == 3:
				array.append(Vector2( i, global_position.y / 16))
			elif i > int(global_position.x / 16) and side == 1:
				array.append(Vector2( i, global_position.y / 16))
	else:
		for i in range(size):
			if i > -int(global_position.y / 16) and side == 0:
				array.append(Vector2(global_position.x / 16, -i))
			elif i < -int(global_position.y / 16) and side == 2:
				array.append(Vector2(global_position.x / 16, -i))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	randomize_side() #move this to only randomize on generate in shop
	attributes = []
	
func randomize_side():
	side = randi_range(0, 3)
	match side:
		1:
			$Sprite.rotation_degrees = 90
		2:
			$Sprite.rotation_degrees = 180
		3:
			$Sprite.rotation_degrees = -90
