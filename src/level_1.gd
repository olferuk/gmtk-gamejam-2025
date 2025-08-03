extends Node2D

@onready var ants: Node2D = $Ants
@onready var camera: Camera2D = $Camera2D
@onready var timer_label: Label = $UI/TimerLabel
@onready var ant_spawner: AntSpawner = $AntSpawner
@onready var game_timer: GameTimer = $GameTimer

const MONET = preload("res://scenes/game_objects/ant_monet.tscn")

const EXAMPLE_DIALOGUE: Array[String] = [
	"Hey there!",
	"It's not me, it's him",
	"And he is standing ooover there!"
]

func _ready() -> void:
	ant_spawner.wave_rows = 3
	ant_spawner.wave_direction = Vector2.RIGHT
	ant_spawner.spawn_delay = 2.0
	ant_spawner.ant_speed = 70.0

	game_timer.initial_time = 10.0
	game_timer.game_over_triggered.connect(_on_game_over)

	#for i in range(15):
		#add_monet_ant(false)
		#var x = int(float(i) / 3)
		#var y = i % 3
		#$Ants.get_child(-1).position = Vector2(x * 40 - 80, y * 40 - 40)

func _process(delta: float) -> void:
	var is_game_over = game_timer.process_timer(delta, timer_label)

	ant_spawner.process_spawning(delta, camera, ants, is_game_over)

func add_monet_ant(is_goal: bool):
	var ant = MONET.instantiate() as AntMonet
	$Ants.add_child(ant)

	var beard_idx = randi() % 3 if randf() < 0.25 else -1
	ant.build(is_goal, randi() % 8, 0, beard_idx)

func _on_game_over() -> void:
	print("beeba?????")
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug_dialogue_start"):
		#DialogueManager.start_dialogue(Vector2(-40, 0), EXAMPLE_DIALOGUE)
