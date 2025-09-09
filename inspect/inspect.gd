extends Control

@export var title : Label
@export var description : Label

@export var upgrade_slot : HBoxContainer

@export var button : TextureButton
@export var button_label : Label

@export var box_1 : HBoxContainer
@export var box_2 : HBoxContainer
@export var box_3 : HBoxContainer

@export var attack : MarginContainer
@export var attack_lbl : Label
@export var health : MarginContainer
@export var health_lbl : Label
@export var max_cd : MarginContainer
@export var max_cd_lbl : Label
@export var current_cd : MarginContainer
@export var current_cd_lbl : Label
@export var manual : MarginContainer
@export var manual_lbl : Label
@export var speed : MarginContainer
@export var speed_lbl : Label

@export var attributes : Control
@export var upgrade_slots : CenterContainer


func _on_activated_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button_label.text = "Activated"
		button.button_pressed = true
		button_label.add_theme_color_override("font_color", Color("03a66b"))
		InspectManager.current_inspected_node.activated = true
	else:
		button_label.text = "Deactivated"
		button.button_pressed = false
		button_label.remove_theme_color_override("font_color")
		InspectManager.current_inspected_node.activated = false


func _on_open_toggled(toggled_on: bool) -> void:
	if toggled_on:
		InspectManager.open = false
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property($".", "global_position:x", $".".global_position.x + 152, 0.3)
		
	else:
		InspectManager.open = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property($".", "global_position:x", $".".global_position.x - 152, 0.3)
		
