extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_component: Node2D = $InteractionComponent

var movement_direction: Vector2 = Vector2.RIGHT
var movement_speed: float = 100.0

func _ready() -> void:
	if animated_sprite:
		animated_sprite.play("walk")
	if interaction_component:
		interaction_component.interaction_started.connect(_on_interaction_started)

	if interaction_component:
		interaction_component.interaction_started.connect(_on_interaction_started)

func _physics_process(_delta: float) -> void:
	velocity = movement_direction * movement_speed
	move_and_slide()

func set_movement(direction_and_speed: Vector2) -> void:
	movement_direction = direction_and_speed.normalized()
	movement_speed = direction_and_speed.length()

func _on_interaction_started() -> void:
	print("BEEBA interaction started!")
