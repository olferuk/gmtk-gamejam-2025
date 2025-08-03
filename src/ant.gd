extends CharacterBody2D

class_name Ant

var is_true: bool = false

@onready var body := $Body
@onready var head := $Head
@onready var sunglasses: Sprite2D = $Sunglasses
@onready var face_features := $FaceFeatures
@onready var limbs := $Limbs
@onready var legs := $Legs
@onready var interaction_component: InteractionComponent = $InteractionComponent

var head_index: int = 0
var body_index: int = 0
var feature_index: int = 0
var sunglasses_index: int = 0

const TILE_SIZE = 32

func _ready():
	head.visible = false
	body.visible = false
	limbs.visible = false
	
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
	body_index = idx_body
	feature_index = idx_feat
	sunglasses_index = idx_glasses
	
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

func _on_interaction_started() -> void:
	print('hi')
