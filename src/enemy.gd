extends CharacterBody2D

# Enemy ant that moves in a circle at fixed radius
class_name Enemy

@export var base_speed: float = 60.0
@export var chaos_factor: float = 0.15 # How much randomness to add
@export var radius_wobble: float = 20.0 # How much radius can vary
@export var speed_variation: float = 0.3 # Speed randomness
@export var player_repulsion_strength: float = 50.0 # How much ants avoid player
@export var player_repulsion_radius: float = 80.0 # Repulsion distance

var animated_sprite: AnimatedSprite2D

var center_position: Vector2
var angle: float = 0.0
var base_radius: float = 0.0 # Original radius
var current_radius: float = 0.0 # Current radius with wobble
var angular_speed: float = 0.0
var speed_multiplier: float = 1.0 # Individual speed variation
var is_active: bool = false

# Chaos variables
var noise_time: float = 0.0
var radius_noise_offset: float = 0.0
var speed_noise_offset: float = 0.0

# Player interaction
var player_node: CharacterBody2D = null

func initialize(center: Vector2, radius: float, start_angle: float):
	center_position = center
	base_radius = radius
	current_radius = base_radius
	angle = start_angle

	# Add individual variations
	speed_multiplier = 1.0 + randf_range(-speed_variation, speed_variation)
	radius_noise_offset = randf() * 1000.0 # Random offset for noise sampling
	speed_noise_offset = randf() * 1000.0

	# Calculate angular speed based on radius (outer circles move slower)
	angular_speed = (base_speed / max(base_radius, 50.0)) * speed_multiplier

	# Position ant on circle with initial wobble
	_update_radius_wobble(0.0)
	global_position = center_position + Vector2(
		cos(angle) * current_radius,
		sin(angle) * current_radius
	)

	is_active = true

	# Get animated sprite reference
	animated_sprite = $AnimatedSprite2D
	animated_sprite.play("walk")

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	noise_time += delta

	# Update radius with wobble and speed variations
	_update_radius_wobble(delta)
	_update_speed_variation(delta)

	# Move clockwise around center with current variations
	angle += angular_speed * speed_multiplier * delta

	# Calculate position on circle with chaos
	var base_pos = center_position + Vector2(
		cos(angle) * current_radius,
		sin(angle) * current_radius
	)

	# Add small random offset for extra chaos
	var chaos_offset = Vector2(
		sin(noise_time * 3.7 + speed_noise_offset) * chaos_factor * 15.0,
		cos(noise_time * 4.1 + speed_noise_offset) * chaos_factor * 12.0
	)

	var target_pos = base_pos + chaos_offset

	# Add player repulsion if player exists
	if player_node != null:
		var player_repulsion = _calculate_player_repulsion()
		target_pos += player_repulsion

	# Calculate movement direction (not perfectly tangent for more natural look)
	var movement_dir = (target_pos - global_position).normalized()
	var tangent_direction = Vector2(-sin(angle), cos(angle))

	# Blend tangent with actual movement for more natural rotation
	var final_direction = (tangent_direction * 0.7 + movement_dir * 0.3).normalized()
	animated_sprite.rotation = final_direction.angle() + PI / 2

	# Move to target position smoothly
	velocity = (target_pos - global_position) * 8.0
	move_and_slide()

func _update_radius_wobble(delta: float):
	# Use sine waves with different frequencies for smooth radius variation
	var wobble = sin(noise_time * 2.3 + radius_noise_offset) * radius_wobble * 0.5
	wobble += sin(noise_time * 1.7 + radius_noise_offset + 50.0) * radius_wobble * 0.3
	current_radius = base_radius + wobble

func _update_speed_variation(delta: float):
	# Subtle speed changes over time
	var speed_wobble = sin(noise_time * 1.1 + speed_noise_offset) * 0.2
	speed_multiplier = 1.0 + randf_range(-speed_variation, speed_variation) * 0.5 + speed_wobble

func set_player_reference(player: CharacterBody2D):
	player_node = player

func _calculate_player_repulsion() -> Vector2:
	if player_node == null:
		return Vector2.ZERO

	var distance_to_player = global_position.distance_to(player_node.global_position)

	if distance_to_player > player_repulsion_radius:
		return Vector2.ZERO

	# Calculate repulsion force (stronger when closer)
	var repulsion_direction = (global_position - player_node.global_position).normalized()
	var repulsion_strength = player_repulsion_strength * (1.0 - distance_to_player / player_repulsion_radius)

	return repulsion_direction * repulsion_strength
