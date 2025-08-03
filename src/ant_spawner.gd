extends Node2D
class_name AntSpawner

@export var wave_rows: int = 3
@export var wave_direction: Vector2 = Vector2.RIGHT
@export var spawn_delay: float = 2.0
@export var ant_speed: float = 70.0

const ANT_SCENE = preload("res://scenes/game_objects/ant.tscn")

var spawn_timer: float = 0.0

func process_spawning(
	delta: float,
	camera: Camera2D,
	ants_container: Node2D,
	is_game_over: bool
) -> void:
	if is_game_over:
		return

	spawn_timer += delta
	if spawn_timer >= spawn_delay:
		spawn_timer = 0.0
		spawn_wave(camera, ants_container)

	cleanup_distant_ants(camera, ants_container)

func spawn_wave(camera: Camera2D, ants_container: Node2D) -> void:
	var camera_bounds = _calculate_camera_bounds(camera)
	var start_y = camera_bounds.position.y + camera_bounds.size.y * 0.4
	var spawn_height = camera_bounds.size.y * 0.5
	var row_spacing = spawn_height / max(1, wave_rows - 1) if wave_rows > 1 else 0

	for row in range(wave_rows):
		var y_pos = start_y + row * row_spacing
		var x_spawn = camera_bounds.position.x - 50

		var ant = ANT_SCENE.instantiate() as Ant
		ants_container.add_child(ant)

		var spacing = 40.0
		ant.global_position = Vector2(
			x_spawn - spacing,
			y_pos + randf_range(-10, 10)
		)

		var beard_idx = randi() % 3 if randf() < 0.25 else -1
		ant.build(false, randi() % 8, 0, beard_idx)

		ant.set_movement(wave_direction * ant_speed)

func cleanup_distant_ants(camera: Camera2D, ants_container: Node2D) -> void:
	var camera_bounds = _calculate_camera_bounds(camera)
	var cleanup_distance = camera_bounds.size.x * 0.6

	for ant in ants_container.get_children():
		if (
			ant.global_position.x >
			camera_bounds.position.x + camera_bounds.size.x + cleanup_distance
		):
			ant.queue_free()

func _calculate_camera_bounds(camera: Camera2D) -> Rect2:
	var viewport_size = get_viewport().get_visible_rect().size / camera.zoom
	var camera_pos = camera.global_position

	return Rect2(
		camera_pos - viewport_size / 2,
		viewport_size
	)
