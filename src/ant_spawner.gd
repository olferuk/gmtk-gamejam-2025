extends Node2D
class_name AntSpawner

@export var max_ants: int = 15
@export var spawn_delay: float = 0.5
@export var min_ant_speed: float = 50.0
@export var max_ant_speed: float = 90.0

var spawn_timer: float = 0.0
var ant_data: Array[Dictionary] = []

func process_spawning(
	delta: float,
	camera: Camera2D,
	ants_container: Node2D,
	is_game_over: bool
) -> void:
	if is_game_over:
		return

	var current_ant_count = ants_container.get_child_count()

	if current_ant_count < max_ants:
		spawn_timer += delta
		if spawn_timer >= spawn_delay:
			spawn_timer = 0.0
			spawn_ant(camera, ants_container)

	teleport_distant_ants(camera)
	update_ant_z_index(ants_container)

func spawn_ant(camera: Camera2D, ants_container: Node2D) -> void:
	var camera_bounds = _calculate_camera_bounds(camera)

	var spawn_on_left = randf() < 0.5
	var spawn_x: float
	var direction_x: float

	if spawn_on_left:
		spawn_x = camera_bounds.position.x - 50
		direction_x = 1.0
	else:
		spawn_x = camera_bounds.position.x + camera_bounds.size.x + 50
		direction_x = -1.0

	var bottom_area_start = camera_bounds.position.y + camera_bounds.size.y * 0.4
	var bottom_area_height = camera_bounds.size.y * 0.6
	var spawn_y = bottom_area_start + randf() * bottom_area_height

	AntBuilder.add_monet_ant(false, ants_container)
	var ant = ants_container.get_child(-1) as Ant
	ant.global_position = Vector2(spawn_x, spawn_y)

	var target_y = bottom_area_start + randf() * bottom_area_height
	var direction = Vector2(direction_x, (target_y - spawn_y) / camera_bounds.size.x * 2)
	direction = direction.normalized()

	var ant_speed = randf_range(min_ant_speed, max_ant_speed)
	ant.set_movement(direction * ant_speed)
	ant.set_sprite_direction(direction)

	ant_data.append({
		"ant": ant,
		"spawn_on_left": spawn_on_left,
		"original_spawn_x": spawn_x,
		"original_spawn_y": spawn_y,
		"direction": direction,
		"speed": ant_speed
	})

func teleport_distant_ants(camera: Camera2D) -> void:
	var camera_bounds = _calculate_camera_bounds(camera)
	var teleport_distance = camera_bounds.size.x * 0.6

	for i in range(ant_data.size() - 1, -1, -1):
		var data = ant_data[i]
		var ant = data.ant as Ant

		if not is_instance_valid(ant):
			ant_data.remove_at(i)
			continue

		var should_teleport = false
		var new_x: float

		if data.spawn_on_left:
			if ant.global_position.x > camera_bounds.position.x + camera_bounds.size.x + teleport_distance:
				should_teleport = true
				new_x = data.original_spawn_x
		else:
			if ant.global_position.x < camera_bounds.position.x - teleport_distance:
				should_teleport = true
				new_x = data.original_spawn_x

		if should_teleport:
			var bottom_area_start = camera_bounds.position.y + camera_bounds.size.y * 0.4
			var bottom_area_height = camera_bounds.size.y * 0.6
			var new_y = bottom_area_start + randf() * bottom_area_height

			ant.global_position = Vector2(new_x, new_y)

			var target_y = bottom_area_start + randf() * bottom_area_height
			var direction_x = 1.0 if data.spawn_on_left else -1.0
			var direction = Vector2(direction_x, (target_y - new_y) / camera_bounds.size.x * 2)
			direction = direction.normalized()

			ant.set_movement(direction * data.speed)
			ant.set_sprite_direction(direction)

			data.direction = direction
			data.original_spawn_y = new_y

func update_ant_z_index(ants_container: Node2D) -> void:
	var ants = ants_container.get_children()
	ants.sort_custom(func(a, b): return a.global_position.y < b.global_position.y)

	for i in range(ants.size()):
		var ant = ants[i] as Ant
		if ant:
			ant.z_index = i

func _calculate_camera_bounds(camera: Camera2D) -> Rect2:
	var viewport_size = get_viewport().get_visible_rect().size / camera.zoom
	var camera_pos = camera.global_position

	return Rect2(
		camera_pos - viewport_size / 2,
		viewport_size
	)
