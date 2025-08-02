extends Node2D

@export var alpha_change_speed := 2.0

var alpha_change_sign := -1.0
var alpha_state := 1.0

@onready var label = $ClickToContinueLabel

func _process(delta):
	modulate_alpha(delta)

func _unhandled_input(event):
	if event.is_pressed():
		get_tree().change_scene_to_file("res://scenes/menus/start_screen.tscn")

func modulate_alpha(delta):
	var da: float = delta * alpha_change_sign * alpha_change_speed
	alpha_state += da

	if alpha_state < 0:
		alpha_change_sign = 1.0
	elif alpha_state > 1:
		alpha_change_sign = -1.0
	alpha_state = clampf(alpha_state, 0, 1)

	label.modulate = Color(1, 1, 1, alpha_state)
