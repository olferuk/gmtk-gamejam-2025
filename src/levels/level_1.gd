extends Node2D

@onready var ants: Node2D = $Ants
@onready var camera: Camera2D = $Camera2D
@onready var timer_label: Label = $UI/TimerLabel
@onready var ant_spawner: AntSpawner = $AntSpawner
@onready var game_timer: GameTimer = $GameTimer

#const EXAMPLE_DIALOGUE: Array[String] = [
	#"Hey there!",
	#"It's not me, it's him",
	#"And he is standing ooover there!"
#]

func _ready() -> void:
	for i in range(18):
		var x = int(float(i) / 3)
		var y = i % 3
		AntBuilder.add_monet_ant(y == 0, $Ants)
		$Ants.get_child(-1).position = Vector2(x * 40 - 80, y * 40 - 40)

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("debug_dialogue_start"):
		#DialogueManager.start_dialogue(Vector2(-40, 0), EXAMPLE_DIALOGUE)
