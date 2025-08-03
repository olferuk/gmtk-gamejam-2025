extends Node2D

@onready var ants: Node2D = $Ants
@onready var camera: Camera2D = $Camera2D
@onready var timer_label: Label = $UI/TimerLabel
@onready var ant_spawner: AntSpawner = $AntSpawner
@onready var game_timer: GameTimer = $GameTimer

var player := 1.

func _ready() -> void:
	ant_spawner.wave_rows = 3
	ant_spawner.wave_direction = Vector2.RIGHT
	ant_spawner.spawn_delay = 2.0
	ant_spawner.ant_speed = 70.0

	game_timer.initial_time = 10.0
	game_timer.game_over_triggered.connect(_game_over)

func _process(delta: float) -> void:
	var is_game_over = game_timer.process_timer(delta, timer_label)
	ant_spawner.process_spawning(delta, camera, ants, is_game_over)


func _game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/game_over.tscn")
