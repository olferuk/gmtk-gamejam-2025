extends Node

@onready var comic_bubble_scene = preload(
	"res://scenes/ui/comic_bubble.tscn"
)

signal finished_dialogue

var dialogue_lines: Array = []
var current_line_index = 0

var text_box
var text_box_pos2d: Vector2

var is_dialogue_active: bool = false
var can_advance_line: bool = false

func start_dialogue(pos: Vector2, lines: Array):
	if is_dialogue_active:
		return
	
	dialogue_lines = lines
	text_box_pos2d = pos
	_show_text_box()
	
	is_dialogue_active = true

func _show_text_box():
	text_box = comic_bubble_scene.instantiate()
	text_box.finish_displaying.connect(_on_text_box_finish_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_pos2d
	text_box.display_text(dialogue_lines[current_line_index])
	can_advance_line = false

func _on_text_box_finish_displaying():
	can_advance_line = true

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("dialogue_proceed")
		&& can_advance_line
		&& is_dialogue_active
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			finished_dialogue.emit()
			return
		
		_show_text_box()
