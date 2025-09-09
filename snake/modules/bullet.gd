extends Node2D

var large = true:
	set(value):
		large = value
		if large:
			$Big.visible = true
			$Small.visible = false
			count = 2
		else:
			$Big.visible = false
			$Small.visible = true
			count = 1

var direction
var damage
var count

func _ready() -> void:
	LevelManager.bullets.append(self)
func move():
	for i in range(count):
		match direction:
			"left":
				global_position.x -= 16
				if global_position.x <= -9:
					LevelManager.bullets.remove_at(LevelManager.bullets.find(self))
					queue_free()
					return
				check_hit()
			"right":
				global_position.x += 16
				if global_position.x >= 315:
					LevelManager.bullets.remove_at(LevelManager.bullets.find(self))
					queue_free()
					return
				check_hit()
			"up":
				global_position.y -= 16
				if global_position.y <= -233:
					LevelManager.bullets.remove_at(LevelManager.bullets.find(self))
					queue_free()
					return
				check_hit()
			"down":
				global_position.y += 16
				if global_position.y >= 7:
					LevelManager.bullets.remove_at(LevelManager.bullets.find(self))
					queue_free()
					return
				check_hit()
		await get_tree().create_timer(0.1).timeout
					
func check_hit():
	var hit_obj = LevelManager.level.return_obj(Vector2(global_position.x, -global_position.y))
	if hit_obj == null:
		return
	if !hit_obj.is_in_group("snake"):
		if hit_obj.has_method("hit"):
			hit_obj.hit(damage)
		LevelManager.bullets.remove_at(LevelManager.bullets.find(self))
		queue_free()
