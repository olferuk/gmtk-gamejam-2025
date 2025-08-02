extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var movement_direction: Vector2 = Vector2.RIGHT
var movement_speed: float = 100.0

func _ready() -> void:
	if animated_sprite:
		animated_sprite.play("walk")

func _physics_process(_delta: float) -> void:
	velocity = movement_direction * movement_speed

	move_and_slide()

func set_movement(direction_and_speed: Vector2) -> void:
	movement_direction = direction_and_speed.normalized()
	movement_speed = direction_and_speed.length()
