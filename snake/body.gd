extends Node2D

@onready var level = get_tree().get_first_node_in_group("level")
@export var module : Node2D

func _ready():
	level.initialize_position(global_position, self)

func move(target_pos, connecting_forward_pos) -> Vector2:
	var connecting_backward_pos = global_position
	global_position = target_pos
		
	var dir_1 = connecting_forward_pos - target_pos
	var str_1
	if dir_1.x > 0:
		str_1 = "right"
	elif dir_1.x < 0:
		str_1 = "left"
	elif dir_1.y > 0:
		str_1 = "down"
	elif dir_1.y < 0:
		str_1 = "up"
	var dir_2 = connecting_backward_pos - target_pos
	var str_2
	if dir_2.x > 0:
		str_2 = "right"
	elif dir_2.x < 0:
		str_2 = "left"
	elif dir_2.y > 0:
		str_2 = "down"
	elif dir_2.y < 0:
		str_2 = "up"
	if (str_1 == "left" or str_1 == "right") and (str_2 == "right" or str_2 == "left"):
		$Straight.visible = true
		$Angle.visible = false
		$Straight.rotation_degrees = 0
	if (str_1 == "up" or str_1 == "down") and (str_2 == "up" or str_2 == "down"):
		$Straight.visible = true
		$Angle.visible = false
		$Straight.rotation_degrees = 90
	if (str_1 == "left" and str_2 == "up") or (str_2 == "left" and str_1 == "up"):
		$Straight.visible = false
		$Angle.visible = true
		$Angle.rotation_degrees = -90
	if (str_1 == "right" and str_2 == "up") or (str_2 == "right" and str_1 == "up"):
		$Straight.visible = false
		$Angle.visible = true
		$Angle.rotation_degrees = 0
	if (str_1 == "left" and str_2 == "down") or (str_2 == "left" and str_1 == "down"):
		$Straight.visible = false
		$Angle.visible = true
		$Angle.rotation_degrees = 180
	if (str_1 == "right" and str_2 == "down") or (str_2 == "right" and str_1 == "down"):
		$Straight.visible = false
		$Angle.visible = true
		$Angle.rotation_degrees = 90
	return connecting_backward_pos 

func activate() -> void:
	module.activate()

func inspect() -> void:
	module.inspect()
