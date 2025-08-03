extends CharacterBody2D

class_name AntBase

var is_true: bool = false

var movement_direction: Vector2 = Vector2.RIGHT
var movement_speed: float = 100.0

@onready var body := $Body
@onready var head := $Head
@onready var face_features := $FaceFeatures
@onready var limbs := $Limbs
@onready var legs := $Legs

@onready var interaction_component: InteractionComponent = $InteractionComponent

@export var head_count: int = 1
@export var body_count: int = 1
@export var features_count: int = 3

var head_index: int = 0
var body_index: int = 0
var feature_index: int = 0

const TILE_SIZE = 32

func _ready():
	head.visible = false
	body.visible = false
	limbs.visible = false
	if interaction_component:
		interaction_component.interaction_started.connect(_on_interaction_started)

# ❗ You must set the textures (like head.texture = ...) before calling build().
func build(is_true_ant: bool, idx_head: int, idx_body: int, idx_feat: int):
	is_true = is_true_ant
	head_index = idx_head
	body_index = idx_body
	feature_index = idx_feat

	_apply_parts()

func _apply_parts():
	head.region_enabled = true
	body.region_enabled = true
	limbs.region_enabled = true

	head.region_rect = _calc_region(head_index, head.texture)
	body.region_rect = _calc_region(body_index, body.texture)
	limbs.region_rect = _calc_region(0, limbs.texture)

	if feature_index >= 0:
		face_features.visible = true
		face_features.region_rect = _calc_region(feature_index, face_features.texture)

	head.visible = true
	body.visible = true
	limbs.visible = true

func _calc_region(index: int, tex: Texture2D) -> Rect2i:
	return Rect2i(index * TILE_SIZE, 0, TILE_SIZE, int(tex.get_size().y))

func _physics_process(_delta: float) -> void:
	if movement_speed > 0:
		velocity = movement_direction * movement_speed
		move_and_slide()

func set_movement(direction_and_speed: Vector2) -> void:
	movement_direction = direction_and_speed.normalized()
	movement_speed = direction_and_speed.length()

func _on_interaction_started() -> void:
	print('beeba')
