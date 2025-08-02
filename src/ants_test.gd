extends Node2D

@export var wave_rows: int = 3
@export var wave_direction: Vector2 = Vector2.RIGHT
@export var spawn_delay: float = 2.0
@export var ant_speed: float = 100.0
@export var ants_per_row: int = 5

@onready var ants: Node2D = $Ants
@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player

const ENEMY_SCENE = preload("res://scenes/game_objects/enemy.tscn")

var camera_bounds: Rect2
var spawn_timer: float = 0.0

func _ready() -> void:
	_calculate_camera_bounds()
	_spawn_wave()

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_delay:
		spawn_timer = 0.0
		_spawn_wave()

	_cleanup_distant_ants()

func _calculate_camera_bounds() -> void:
	var viewport_size = get_viewport().get_visible_rect().size / camera.zoom
	var camera_pos = camera.global_position

	camera_bounds = Rect2(
		camera_pos - viewport_size / 2,
		viewport_size
	)

func _spawn_wave() -> void:
	var start_y = camera_bounds.position.y + camera_bounds.size.y * 0.4
	var spawn_height = camera_bounds.size.y * 0.5
	var row_spacing = spawn_height / max(1, wave_rows - 1) if wave_rows > 1 else 0

	for row in range(wave_rows):
		var y_pos = start_y + row * row_spacing
		var x_spawn = camera_bounds.position.x - 50

		for ant_idx in range(ants_per_row):
			var ant = ENEMY_SCENE.instantiate()
			ants.add_child(ant)

			var spacing = 40.0
			ant.global_position = Vector2(
				x_spawn - ant_idx * spacing,
				y_pos + randf_range(-10, 10)
			)

			if ant.has_method("set_movement"):
				ant.set_movement(wave_direction * ant_speed)

func _cleanup_distant_ants() -> void:
	var cleanup_distance = camera_bounds.size.x * 0.6

	for ant in ants.get_children():
		if ant.global_position.x > camera_bounds.position.x + camera_bounds.size.x + cleanup_distance:
			ant.queue_free()
