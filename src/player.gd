extends CharacterBody2D

@export var speed: float = 200.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var camera_bounds: Rect2

func _ready() -> void:
	_update_camera_bounds()

func _physics_process(delta: float) -> void:
	_update_camera_bounds()
	_handle_movement(delta)
	_update_animation()
	_clamp_to_camera_bounds()

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
	if camera:
		var viewport_size = get_viewport().get_visible_rect().size / camera.zoom
		var camera_pos = camera.global_position

		camera_bounds = Rect2(
			camera_pos - viewport_size / 2,
			viewport_size
		)

func _clamp_to_camera_bounds() -> void:
	if camera_bounds.size != Vector2.ZERO:
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
