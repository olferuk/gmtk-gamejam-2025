extends CharacterBody2D

class_name Ant

var is_true: bool = false

var movement_direction: Vector2 = Vector2.RIGHT
@export var movement_speed: float = 0.0
var should_be_moving: float = 1.0

@onready var body := $Body
@onready var clothes := $Body/Clothes
@onready var head := $Head
@onready var sunglasses := $Head/Sunglasses
@onready var face_features := $Head/FaceFeatures
@onready var limbs := $Limbs
@onready var legs := $Legs
@onready var interaction_component := $InteractionComponent

var head_index: int = 0
var feature_index: int = 0
var sunglasses_index: int = 0
var clothes_index: int = 0

const TILE_SIZE = 32

func _ready():
	if interaction_component:
		interaction_component.interaction_started.connect(_on_interaction_started)

# ❗ You must set the textures (like head.texture = ...)
#    before calling build().
func build(
	is_target: bool,
	idx_head: int,
	idx_body: int,
	idx_feat: int = -1,
	idx_glasses: int = -1
):
	is_true = is_target

	head_index = idx_head
	feature_index = idx_feat
	sunglasses_index = idx_glasses

	clothes_index = idx_body

	_apply_parts()

func _apply_parts():
	head.region_rect = _calc_region(head_index, head.texture)

	if clothes_index == AntBuilder.NONE:
		clothes.visible = false
	else:
		clothes.visible = true
		clothes.region_rect = _calc_region(clothes_index, clothes.texture)

	limbs.region_rect = _calc_region(0, limbs.texture)

	if feature_index >= 0:
		face_features.visible = true
		face_features.region_rect = _calc_region(feature_index, face_features.texture)

func _calc_region(index: int, tex: Texture2D) -> Rect2i:
	return Rect2i(index * TILE_SIZE, 0, TILE_SIZE, int(tex.get_size().y))

# movement

func _physics_process(_delta: float) -> void:
	if movement_speed > 0:
		velocity = movement_direction * movement_speed * should_be_moving
		move_and_slide()

func set_movement(direction_and_speed: Vector2) -> void:
	movement_direction = direction_and_speed.normalized()
	movement_speed = direction_and_speed.length()

func set_sprite_direction(direction: Vector2) -> void:
	var direction_scale = 1.0 if direction.x >= 0 else -1.0

	body.scale.x = direction_scale
	head.scale.x = direction_scale
	limbs.scale.x = direction_scale
	legs.scale.x = direction_scale

# interaction

func _on_interaction_started() -> void:
	should_be_moving = 0.0
	var text = []
	if is_true:
		text = LevelManager.success_msgs
	else:
		text = LevelManager.wrong_msgs[randi() % LevelManager.wrong_msgs.size()]
	
	DialogueManager.start_dialogue(position, text)
	DialogueManager.finished_dialogue.connect(
		_on_interaction_ended,
		ConnectFlags.CONNECT_ONE_SHOT
	)

func _on_interaction_ended() -> void:
	should_be_moving = 1.0
	if is_true:
		await get_tree().create_timer(0.4).timeout
		LevelManager.load_next_level()
		get_tree().change_scene_to_file("res://scenes/ui/start_screen.tscn")
