extends CharacterBody2D

@export var SPEED = 375.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# Get input direction vector for 8-directional movement
	var input_vector = Input.get_vector(
		"ui_left", "ui_right", "ui_up", "ui_down"
	)
	
	# Apply movement
	if input_vector != Vector2.ZERO:
		velocity = input_vector * SPEED
	
		# Rotate sprite to face movement direction 
		#  (compensate for sprite facing up initially)
		animated_sprite.rotation = input_vector.angle() + PI / 2
	
		# Play walk animation if not already playing
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
	else:
		velocity = Vector2.ZERO

		# Play idle animation if not already playing
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

	move_and_slide()
