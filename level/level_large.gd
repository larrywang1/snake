extends Node2D

@export var snake_node : Node2D
var grid = {
	0.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	1.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	2.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	3.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	4.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	5.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	6.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	7.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	8.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	9.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	10.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	11.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	12.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	13.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
	14.0: [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],	
}
var grid_size = Vector2i(20, 15)

func initialize_position(pos : Vector2, obj) -> Vector2:
	var x = pos.x / 16
	var y = pos.y / -16
	grid[y][x] = obj
	return Vector2(x, y)

func update_position(new_position : Vector2, old_position : Vector2, obj):
	var old_x = old_position.x / 16
	var old_y = old_position.y / -16
	var new_x = new_position.x / 16
	var new_y = new_position.y / -16
	if grid[old_y][old_x] == obj:
		grid[old_y][old_x] = null
	grid[new_y][new_x] = obj

func remove_position(pos : Vector2):
	var x = pos.x / 16
	var y = pos.y / -16
	grid[y][x] = null

func return_position(pos : Vector2) -> Vector2:
	var x = pos.x / 16
	var y = pos.y / -16
	return Vector2(x, y)

func return_obj(pos):
	return grid[pos.y / 16][pos.x / 16]

var cell_pos = Vector2(-1, -1)
var mouse_pressed : bool = false
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var prev_cell_pos = cell_pos
	if mouse_pos.x > -8 and mouse_pos.x < 312 and mouse_pos.y < 8 and mouse_pos.y > -232:
		cell_pos.x = roundi(mouse_pos.x / 16)
		cell_pos.y = roundi(mouse_pos.y / 16)
	else:
		cell_pos = Vector2(-1, -1)
		$TileMap/White.clear()
	if cell_pos != Vector2(-1, -1) and cell_pos != prev_cell_pos:
		$TileMap/White.clear()
		$TileMap/White.set_cell(cell_pos, 0, Vector2i(0, 0))
	
	if !mouse_pressed and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if InspectManager.is_inspect and InspectManager.open:
			if 240 < mouse_pos.x and mouse_pos.x < 376 and mouse_pos.y < 7 and mouse_pos.y > -231:
				return
			if 224 < mouse_pos.x and mouse_pos.x < 240 and mouse_pos.y < -213 and mouse_pos.y > -229:
				return
		if InspectManager.is_inspect and !InspectManager.open:
			if 375 < mouse_pos.x and mouse_pos.x < 392 and mouse_pos.y < -213 and mouse_pos.y > -229:
				return
		if cell_pos != Vector2(-1, -1):
			if grid[-cell_pos.y][cell_pos.x] != null:
				if grid[-cell_pos.y][cell_pos.x].has_method("inspect"):
					grid[-cell_pos.y][cell_pos.x].inspect()
				else:
					InspectManager.remove_inspect()
			else:
				InspectManager.remove_inspect()
		else:
			InspectManager.remove_inspect()
	mouse_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
func _ready() -> void:
	LevelManager.level = self
	LevelManager.create_snake()
