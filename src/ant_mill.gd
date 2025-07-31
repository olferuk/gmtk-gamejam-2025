extends Node2D

# Ant Mill system - manages concentric circles of ants
class_name AntMill

@export var enemy_scene: PackedScene
@export var max_radius: float = 1000.0 # Outer circle radius
@export var min_radius: float = 160.0 # Inner circle radius
@export var circle_count: int = 15 # Number of concentric circles
@export var ants_per_circle: int = 12 # Base number of ants per circle

var center_position: Vector2
var active_ants: Array[Enemy] = []
var player_node: CharacterBody2D = null

func _ready():
	# Set center to (0, 0)
	center_position = Vector2.ZERO

	# Load enemy scene if not set
	if not enemy_scene:
		enemy_scene = preload("res://scenes/game_objects/enemy.tscn")

	# Find player node
	call_deferred("_find_player")

	# Generate all ants at start
	generate_all_ants()

func generate_all_ants():
	var radius_step = (max_radius - min_radius) / float(circle_count - 1)

	for circle_index in range(circle_count):
		var current_radius = min_radius + (radius_step * circle_index)

		# More ants on outer circles (proportional to circumference)
		var ants_on_this_circle = int(ants_per_circle * (current_radius / min_radius))
		ants_on_this_circle = max(ants_on_this_circle, 6) # Minimum 6 ants per circle

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

func _find_player():
	# Find player node in parent
	var main_node = get_parent()
	if main_node:
		player_node = main_node.get_node("Player")

		# Update existing ants with player reference
		for ant in active_ants:
			if is_instance_valid(ant):
				ant.set_player_reference(player_node)

#func _draw():
	## Debug visualization (remove in final version)
	#if Engine.is_editor_hint():
		#return
#
	## Draw concentric circles for reference
	#var radius_step = (max_radius - min_radius) / float(circle_count - 1)
#
	#for i in range(circle_count):
		#var radius = min_radius + (radius_step * i)
		#var alpha = 0.3 - (i * 0.02) # Fade outer circles
		#draw_arc(center_position, radius, 0, TAU, 64, Color(1, 1, 1, alpha), 1.0)
#
	## Draw center point
	#draw_circle(center_position, 5, Color.RED)
