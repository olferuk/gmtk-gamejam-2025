extends Node2D

class_name AntBase

var is_true: bool = false

@onready var body := $Body
@onready var head := $Head
@onready var face_features := $FaceFeatures
@onready var limbs := $Limbs

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

# ❗ You must set the textures (like head.texture = ...) 
#    before calling build().
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
	
	if feature_index >= 0:
		face_features.visible = true
		face_features.region_rect = _calc_region(feature_index, face_features.texture)
	
	head.visible = true
	body.visible = true
	limbs.visible = true

func _calc_region(index: int, tex: Texture2D) -> Rect2i:
	return Rect2i(index * TILE_SIZE, 0, TILE_SIZE, int(tex.get_size().y))
