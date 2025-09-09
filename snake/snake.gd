extends Node2D

@onready var level = get_tree().get_first_node_in_group("level")
@onready var up = %Up
@onready var down = %Down
@onready var right = %Right
@onready var left = %Left
var available_moves = []
var can_move = true
enum snake_types {DEFAULT}
var type : snake_types = snake_types.DEFAULT
func _ready():
	level.initialize_position(global_position, self)
	call_deferred("initialize_moves")

func initialize_moves():
	LevelManager.list_of_snake = [self]
	for i in $"../Body".get_children():
		if i.is_in_group("tail"):
			continue
		LevelManager.list_of_snake.append(i.module)
	available_moves = []
	var pos = level.return_position(Vector2i(global_position))
	pos.x = int(pos.x)
	pos.y = int(pos.y)
	
	if pos.x + 1 <= level.grid_size.x - 1: # minus 1 cuz grid_size is one larger than the largest y value in grid(14)
		if level.grid[pos.y][pos.x + 1] == null:
			right.visible = true
			right.disabled = false
			available_moves.append("right")
		else: 
			button_disable(right)
	else:
		button_disable(right)
	if pos.x - 1 >= 0:
		if level.grid[pos.y][pos.x - 1] == null:
			left.visible = true
			left.disabled = false
			available_moves.append("left")
		else: 
			button_disable(left)
	else:
		button_disable(left)
	if pos.y + 1 <= level.grid_size.y - 1:
		if level.grid[pos.y + 1][pos.x] == null:
			up.visible = true
			up.disabled = false
			available_moves.append("up")
		else: 
			button_disable(up)
	else:
		button_disable(up)
	if pos.y - 1 >= 0:
		if level.grid[pos.y - 1][pos.x] == null:
			down.visible = true
			down.disabled = false
			available_moves.append("down")
		else: 
			button_disable(down)
	else:
		button_disable(down)
	can_move = true

func end_turn(direction : String):
	InspectManager.remove_inspect()
	can_move = false
	%Up.visible = false
	%Down.visible = false
	%Left.visible = false
	%Right.visible = false
	for i in [self] + $"../Body".get_children():
		if i.has_method("activate"):
			i.activate()
			await EventBus.ability_finished
	
	if activated and type == snake_types.DEFAULT:
		#enemy moves
		for i in LevelManager.bullets:
			i.move()
		initialize_moves()
		activated = false
		cd = max_cd
		return
	
	var old_pos = global_position
	match direction:
		"left":
			global_position.x -= 16
			$HeadSprite.rotation_degrees = 180
		"right":
			global_position.x += 16
			$HeadSprite.rotation_degrees = 0
		"down":
			global_position.y += 16
			$HeadSprite.rotation_degrees = 90
		"up":
			global_position.y -= 16
			$HeadSprite.rotation_degrees = -90
	level.update_position(global_position, old_pos, self)
	
	var bodies = [self] + $"../Body".get_children()
	var bodies_size = bodies.size()
	for i in range(bodies_size):
		if i == 0:
			continue
		if i != bodies_size - 1:
			level.update_position(old_pos, bodies[i].global_position, bodies[i])
		var pos = bodies[i].move(old_pos, bodies[i - 1].global_position)
		old_pos = pos
		
	var bullet_list = []
	for i in LevelManager.bullets:
		bullet_list.append(i)
	for i in bullet_list:
		i.move()
	initialize_moves()

func button_disable(button):
	button.visible = false
	button.disabled = true

func _on_up_pressed() -> void:
	end_turn("up")

func _on_down_pressed() -> void:
	end_turn("down")

func _on_right_pressed() -> void:
	end_turn("right")

func _on_left_pressed() -> void:
	end_turn("left")

func _input(event: InputEvent) -> void:
	if !can_move:
		return
	if event.is_action_pressed("up") and "up" in available_moves:
		end_turn("up")
	elif event.is_action_pressed("down") and "down" in available_moves:
		end_turn("down")
	elif event.is_action_pressed("right") and "right" in available_moves:
		end_turn("right")
	elif event.is_action_pressed("left") and "left" in available_moves:
		end_turn("left")

func activate() -> void:
	match type:
		snake_types.DEFAULT:
			pass
	if cd > 0:
		cd -= 1
	await get_tree().create_timer(0.02).timeout
	EventBus.ability_finished.emit()
	
var max_cd = 3
var cd = 3
var activated = false
var can_activate = false
var upgraded = 0
var unupgraded = 3
var guard
var has_guard = false
var bonus_health = 0
var attributes = []
func inspect():
	if cd == 0:
		can_activate = true
	else:
		can_activate = false
	match type:
		snake_types.DEFAULT:
			InspectManager.add_inspect(self, "Snake","Skip Moving for One Turn", {"health" : WorldManager.snake_health, "manual" : "O", "max_cd" : max_cd, "current_cd" : cd}, can_activate, activated, upgraded, unupgraded, attributes)
