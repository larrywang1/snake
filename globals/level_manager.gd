extends Node

var level
var is_in_level = true
var list_of_snake = []

var bullets = []

func create_snake():
	var snake = preload("res://snake/snake.tscn").instantiate()
	#pull from world manager snake type and health
	
	# need to adjust for more than 10 size bodies
	var body_count = 1
	for i in ModuleManager.modules:
		var body = preload("res://snake/body.tscn").instantiate()
		i.init()
		body.add_child(i)
		snake.bodies.add_child(body)
		body.module = i
		body.global_position.x -= 16 * body_count
		body_count += 1
	var tail = preload("res://snake/tail.tscn").instantiate()
	tail.global_position.x -= 16 * body_count
	snake.bodies.add_child(tail)
	snake.global_position.x = 144 + (round(body_count / 2.0) * 16)
	snake.global_position.y = -112
	level.snake_node.add_child(snake)
