extends Node

var current_level: int = 1
var level_title: String = ""
var level_intro: String = ""
var success_msgs: Array = []
var wrong_msgs: Array = []


func load_level_1():
	current_level = 1
	populate(read_json_file("res://data/level_builders.json"))

func load_level_2():
	current_level = 2
	populate(read_json_file("res://data/level_students.json"))

func load_level_3():
	current_level = 3
	populate(read_json_file("res://data/level_gentlemen.json"))

func load_level_4():
	current_level = 4
	populate(read_json_file("res://data/level_monet.json"))

func populate(data: Dictionary):
	level_title = data["intro_title"]
	level_intro = data["intro"]
	success_msgs = data["success_msgs"]
	wrong_msgs = data["wrong_msgs"]

func read_json_file(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Cannot open file: %s" % path)
		return {}

	var content: String = file.get_as_text()
	var result: Variant = JSON.parse_string(content)

	if result == null:
		push_error("Invalid JSON format in: %s" % path)
		print("Invalid JSON format")
		return {}

	if result is Dictionary:
		return result as Dictionary
	else:
		push_error("JSON root is not a dictionary in: %s" % path)
		print("JSON root is not a dictionary")
		return {}
