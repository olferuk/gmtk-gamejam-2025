extends Node

const ANT = preload("res://scenes/game_objects/ant.tscn")

const NONE = -1
const ANY = 100

func add_monet_ant(is_target: bool, parent_node: Node):
	var ant = _create_and_add(parent_node)
	
	ant.head.texture = preload("res://vfx/sprite_sheets/heads-monet.png")
	ant.body.texture = preload("res://vfx/sprite_sheets/body-monet.png")
	
	var head_index = 9 if is_target else randi() % 9
	var body_index = randi() % 2 if randf() < 0.8 else -1
	var beard_idx = randi() % 3 if randf() < 0.25 else -1
	ant.build(is_target, head_index, body_index, beard_idx)

func add_worker_ant(is_target: bool, parent_node: Node):
	var ant = _create_and_add(parent_node)
	
	ant.head.texture = preload("res://vfx/sprite_sheets/heads_safety.png")
	ant.body.texture = preload("res://vfx/sprite_sheets/body_jackets.png")
	
	var head_index = 1 if is_target else 0
	var body_index = 0 if randf() < 0.5 else 3
	var beard_idx = 0 if randf() < 0.7 else NONE
	ant.build(is_target, head_index, body_index, beard_idx)

func add_gentleman(is_target: bool, parent_node: Node):
	var ant = _create_and_add(parent_node)
	
	ant.head.texture = preload("res://vfx/sprite_sheets/heads_gentlemen.png")
	ant.body.texture = preload("res://vfx/sprite_sheets/body-gentlemen.png")
	
	var head_index = 1 if is_target else 0
	var body_index = 0
	var beard_idx = randi() % 2 + 1 if randf() < 0.7 else NONE
	ant.build(is_target, head_index, body_index, beard_idx)


func _create_and_add(parent_node):
	var ant = ANT.instantiate()
	parent_node.add_child(ant)
	return ant
