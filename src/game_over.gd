extends Control

@export var blink_speed: float = 2.0

@onready var continue_label: Label = $CenterContainer/VBoxContainer/ContinueLabel

var blink_timer: float = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_update_blink_animation(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.keycode == KEY_SPACE and event.pressed):
		_try_again()

func _update_blink_animation(delta: float) -> void:
	blink_timer += delta * blink_speed
	var alpha = (sin(blink_timer) + 1.0) / 2.0
	continue_label.modulate = Color(1, 1, 1, alpha)

func _try_again() -> void:
	get_tree().change_scene_to_file("res://scenes/ants_test.tscn")