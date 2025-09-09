extends Module
@export var damage : int
var bullet_scene = preload("res://snake/modules/bullet.tscn")

func ability():
	#apply on attack buffs here
	#for laser apply on hit here as well, for others apply it right before hit
	for side in [0,1,2,3]:
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
	await get_tree().create_timer(0.2).timeout
	EventBus.ability_finished.emit()

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"

		InspectManager.add_inspect(self, "BD-B-SA", "Fires a bullet in all four directions", {"attack": damage, "health": health, "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string, "velocity" : 1}, manual, activated, upgraded, unupgraded, attributes)
		
	var size = get_tree().get_first_node_in_group("level").grid_size.x 
	var array = []
	for i in range(size):
		if i < int(global_position.x / 16):
			array.append(Vector2( i, global_position.y / 16))
		elif i > int(global_position.x / 16):
			array.append(Vector2( i, global_position.y / 16))
	size = get_tree().get_first_node_in_group("level").grid_size.y
	for i in range(size):
		if i > -int(global_position.y / 16):
			array.append(Vector2(global_position.x / 16, -i))
		elif i < -int(global_position.y / 16):
			array.append(Vector2(global_position.x / 16, -i))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	attributes = []
