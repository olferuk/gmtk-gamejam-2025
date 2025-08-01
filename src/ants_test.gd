extends Node2D

@onready var ants: Node2D = $Ants

const MONET = preload("res://scenes/game_objects/ant_monet.tscn")

func _ready() -> void:
	for i in range(10):
		add_ant(false)

func add_ant(is_goal: bool):
	var ant_scene = MONET
	var ant = ant_scene.instantiate() as AntMonet
	$Ants.add_child(ant)
	ant.build(is_goal, randi() % 8, 0)
	ant.position = Vector2(randi() % 50 - 25, randi() % 50 - 25)
