extends Control

@export var blink_speed: float = 3.0

@onready var continue_label: Label = $CenterContainer/VBoxContainer/ContinueLabel

@onready var level_title: Label = $CenterContainer/VBoxContainer/LevelTitle
@onready var intro_text: Label = $CenterContainer/VBoxContainer/Intro


var blink_timer: float = 0.0

func _ready():
	load_level()

func load_level():
	level_title.text = LevelManager.level_title
	intro_text.text = LevelManager.level_intro

func _process(delta: float) -> void:
	_update_blink_animation(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.keycode == KEY_SPACE and event.pressed):
		_start_game()

func _update_blink_animation(delta: float) -> void:
	blink_timer += delta * blink_speed
	var alpha = (sin(blink_timer) + 1.0) / 2.0
	continue_label.modulate = Color(1, 1, 1, alpha)

func _start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level-1.tscn")
