extends Node2D
class_name Module

@export var max_health : int
var health = max_health
@export var current_cooldown : int
@export var cooldown : int
@export var manual : bool
@export var unupgraded : int
var upgraded : int = 0
var activated = true if !manual else false
var guard
var has_guard = false
var bonus_health = 0
var attributes = []
var manual_string

func activate() -> void:
	if current_cooldown <= 0:
		if !manual and activated:
			current_cooldown = cooldown
			ability()
			
		else:
			await get_tree().create_timer(0.02).timeout
			EventBus.ability_finished.emit()
	else:
		current_cooldown -= 1
		await get_tree().create_timer(0.02).timeout
		EventBus.ability_finished.emit()

func ability():
	pass

func inspect():
	pass

func init():
	pass
