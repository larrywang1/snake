extends Node2D

@onready var level = get_tree().get_first_node_in_group("level")

#func _ready():
	#level.initialize_position(global_position, self)

func move(target_pos, connecting_forward_pos) -> Vector2:
	var connecting_backward_pos = global_position
	global_position = target_pos
	var dir_1 = connecting_forward_pos - target_pos
	if dir_1.x > 0:
		$Sprite.rotation_degrees = 0
	elif dir_1.x < 0:
		$Sprite.rotation_degrees = 180
	elif dir_1.y > 0:
		$Sprite.rotation_degrees = 90
	elif dir_1.y < 0:
		$Sprite.rotation_degrees = -90
	
	return connecting_backward_pos 
