extends Node2D

@onready var ants: Node2D = $Ants

const MONET = preload("res://scenes/game_objects/ant_monet.tscn")

func _ready() -> void:
	for i in range(15):
		add_monet_ant(false)
		var x = int(i / 3)
		var y = i % 3
		$Ants.get_child(-1).position = Vector2(x * 40 - 80, y * 40 - 40)

func add_monet_ant(is_goal: bool):
	var ant = MONET.instantiate() as AntMonet
	$Ants.add_child(ant)

	# Customize
	var beard_idx = randi() % 3 if randf() < 0.25 else -1
	ant.build(is_goal, randi() % 8, 0, beard_idx)
