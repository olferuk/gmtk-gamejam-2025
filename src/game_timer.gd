extends Node
class_name GameTimer

signal game_over_triggered

@export var initial_time: float = 10.0

var current_time: float
var is_finished: bool = false

func _ready() -> void:
	current_time = initial_time

func process_timer(delta: float, timer_label: Label) -> bool:
	if is_finished:
		return true

	current_time -= delta

	if current_time <= 0:
		current_time = 0
		is_finished = true
		game_over_triggered.emit()

	update_timer_display(timer_label)
	return is_finished

func update_timer_display(timer_label: Label) -> void:
	var minutes = int(current_time / 60)
	var seconds = int(current_time) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func reset_timer(new_time: float = 0.0) -> void:
	if new_time > 0:
		initial_time = new_time
	current_time = initial_time
	is_finished = false

func get_time_remaining() -> float:
	return current_time

func is_game_over() -> bool:
	return is_finished