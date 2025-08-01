extends Node2D

class_name AntMill

@export var enemy_scene: PackedScene = preload(
	"res://scenes/game_objects/enemy.tscn"
)
@export var min_radius: float = 160.0
@export var max_radius: float = 1000.0
@export var circle_count: int = 10
@export var ants_per_circle: int = 12

var center_position: Vector2
var active_ants: Array[Enemy] = []
var player_node: CharacterBody2D = null

const HAT_ATLAS = preload("res://vfx/sprite_sheets/Ants-hats-export.png")
const HAT_ATLAS_BUGS = preload("res://vfx/sprite_sheets/Bugs-hats-export.png")
const HAT_ROWS = 8
const HAT_COLUMNS = 12

var HAT_SIZE := HAT_ATLAS.get_size() / Vector2(HAT_COLUMNS, HAT_ROWS)

const THE_ROW = 3
const THE_ROW_BUGS = 0
const HATS_INDICES = [0, 1, 2, 3]
const HATS_INDICES_BUGS = [0, 1, 2, 3, 4]

func _ready():
	center_position = Vector2.ZERO
	call_deferred("_find_player")
	generate_all_ants()

func generate_all_ants():
	var radius_step = (max_radius - min_radius) / float(circle_count - 1)

	for circle_index in range(circle_count):
		var current_radius = min_radius + (radius_step * circle_index)

		# More ants on outer circles (proportional to circumference)
		var ants_on_this_circle = int(
			ants_per_circle * (current_radius / min_radius)
		)
		# Minimum 6 ants per circle
		ants_on_this_circle = max(ants_on_this_circle, 6)

		var angle_step = TAU / float(ants_on_this_circle)

		# Random offset for each circle to avoid perfect alignment
		var circle_offset = randf() * angle_step

		for ant_index in range(ants_on_this_circle):
			var ant_angle = (ant_index * angle_step) + circle_offset
			spawn_ant_at_position(current_radius, ant_angle)

func spawn_ant_at_position(radius: float, angle: float):
	var new_ant = enemy_scene.instantiate() as Enemy
	add_child(new_ant)

	# Initialize ant with circle parameters
	new_ant.initialize(center_position, radius, angle)

	# Set player reference for interaction
	if player_node != null:
		new_ant.set_player_reference(player_node)

	active_ants.append(new_ant)
	
	give_ant_hat(new_ant)

func give_ant_hat(ant: Enemy):
	var for_bug = randi() % 2
	var index: int
	var atlas: Texture2D
	if for_bug:
		index = HATS_INDICES_BUGS[randi() % len(HATS_INDICES_BUGS)]
		atlas = HAT_ATLAS_BUGS
	else:
		index = HATS_INDICES[randi() % len(HATS_INDICES)]
		atlas = HAT_ATLAS
	var row = THE_ROW_BUGS if for_bug else THE_ROW
	var region = Rect2(
		index*HAT_SIZE.x,
		row*HAT_SIZE.y,
		HAT_SIZE.x,
		HAT_SIZE.y
	)
	ant.get_hat(index, atlas, region)

func _find_player():
	# Find player node in parent
	var main_node = get_parent()
	if main_node:
		player_node = main_node.get_node("Player")

		# Update existing ants with player reference
		for ant in active_ants:
			if is_instance_valid(ant):
				ant.set_player_reference(player_node)
