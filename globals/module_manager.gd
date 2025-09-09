extends Node

var modules = [preload("res://snake/modules/bd_l_am.tscn").instantiate(), preload("res://snake/modules/bd_b_aa.tscn").instantiate(), preload("res://snake/modules/bd_h_hn.tscn").instantiate()]
var snake = preload("res://snake/snake.tscn").instantiate()

func hit(module, damage):
	if module.has_guard:
		module.has_guard = false
		module.guard.queue_free()
		return
	if module.bonus_health > 0:
		module.bonus_health = max(module.bonus_health - damage, 0)
		var excess_damage = module.bonus_health - damage
		module.health += excess_damage
	else:
		module.health -= damage
	if module.health <= 0:
		module.health = 0
		module.deactivate()
