extends Module

var strength = 3


func ability():
	var level = LevelManager.level
	var index = LevelManager.list_of_snake.find(self)
	LevelManager.list_of_snake[index - 1].current_cooldown += 1
	if index < LevelManager.list_of_snake.size():
		LevelManager.list_of_snake[index + 1].current_cooldown -= strength
	await get_tree().create_timer(0.05).timeout
	EventBus.ability_finished.emit()

func inspect():
	if manual:
		manual_string = "O"
	else:
		manual_string = "X"
	InspectManager.add_inspect(self, "BD-CD-F", "Reduce the cooldown of the next module and increase the cooldown of the previous module by 1", {"attack" : strength,"health": health,  "max_cd" : cooldown, "current_cd" : current_cooldown, "manual" : manual_string}, manual, activated, upgraded, unupgraded, attributes)
	var array = []
	array.append(Vector2i(LevelManager.list_of_snake[LevelManager.list_of_snake.find(self) - 1].global_position / 16))
	if LevelManager.list_of_snake.find(self) < LevelManager.list_of_snake.size():
		array.append(Vector2i(LevelManager.list_of_snake[LevelManager.list_of_snake.find(self) + 1].global_position / 16))
	InspectManager.create_tiles(array)

func init():
	current_cooldown = cooldown
	health = max_health
	activated = true if !manual else false
	attributes = []
