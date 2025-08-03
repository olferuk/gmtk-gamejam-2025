extends CharacterBody2D

@export var speed: float = 200.0

@onready var animated_sprite := $Legs
@onready var interaction_raycast: RayCast2D = $InteractionRayCast

var camera_bounds: Rect2
var current_interactable: CharacterBody2D = null
var last_movement_direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	_update_camera_bounds()

func _physics_process(delta: float) -> void:
	_update_camera_bounds()
	_handle_movement(delta)
	_update_animation()
	_clamp_to_camera_bounds()
	_handle_interaction_detection()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_perform_interaction()

func _handle_movement(_delta: float) -> void:
	var input_vector = Input.get_vector(
		"ui_left", "ui_right", "ui_up", "ui_down"
	)
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _update_animation() -> void:
	if velocity != Vector2.ZERO:
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

func _update_camera_bounds() -> void:
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	var viewport_size = get_viewport().get_visible_rect().size / camera.zoom
	var camera_pos = camera.global_position

	camera_bounds = Rect2(
		camera_pos - viewport_size / 2,
		viewport_size
	)

func _clamp_to_camera_bounds() -> void:
	if camera_bounds.size == Vector2.ZERO:
		return
	var margin = 20.0
	global_position.x = clampf(
		global_position.x,
		camera_bounds.position.x + margin,
		camera_bounds.position.x + camera_bounds.size.x - margin
	)
	global_position.y = clampf(
		global_position.y,
		camera_bounds.position.y + margin,
		camera_bounds.position.y + camera_bounds.size.y - margin
	)

func _handle_interaction_detection() -> void:
	if not interaction_raycast:
		return

	_update_raycast_direction()

	var new_interactable: CharacterBody2D = null

	if interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()
		if collider is CharacterBody2D and collider.has_node("InteractionComponent"):
			new_interactable = collider

	if not new_interactable:
		new_interactable = _find_interactable_in_nearby_directions()

	if current_interactable != new_interactable:
		_set_current_interactable(new_interactable)

func _update_raycast_direction() -> void:
	if velocity.length() > 0:
		last_movement_direction = velocity.normalized()
	interaction_raycast.target_position = last_movement_direction * 18.0

func _set_current_interactable(interactable: CharacterBody2D) -> void:
	if current_interactable and is_instance_valid(current_interactable):
		var old_component = current_interactable.get_node("InteractionComponent")
		if old_component and old_component.has_method("set_player_in_range"):
			old_component.set_player_in_range(false)

	current_interactable = interactable

	if current_interactable:
		var component = current_interactable.get_node("InteractionComponent")
		if component and component.has_method("set_player_in_range"):
			component.set_player_in_range(true)

func _find_interactable_in_nearby_directions() -> CharacterBody2D:
	if not interaction_raycast:
		return null

	var search_directions = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN
	]

	var original_target = interaction_raycast.target_position

	for direction in search_directions:
		if direction.is_equal_approx(last_movement_direction):
			continue

		interaction_raycast.target_position = direction * 59.0
		interaction_raycast.force_raycast_update()

		if interaction_raycast.is_colliding():
			var collider = interaction_raycast.get_collider()
			if collider is CharacterBody2D and collider.has_node("InteractionComponent"):
				interaction_raycast.target_position = original_target
				return collider

	interaction_raycast.target_position = original_target
	return null

func _perform_interaction() -> void:
	if not current_interactable or not is_instance_valid(current_interactable):
		return

	var component = current_interactable.get_node("InteractionComponent")
	if component and component.has_method("interact"):
		component.interact()
