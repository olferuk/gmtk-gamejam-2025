extends Node2D

class_name AntBase

@onready var head := $Head
@onready var body := $Body
@onready var limbs := $Limbs

@export var head_count: int = -1
#@export var body_count: int = -1

var head_index: int
#var body_index: int

var is_true: bool = false

func _ready():
	head.visible = false
	body.visible = false
	limbs.visible = false

# ❗ You must set the textures (like head.texture = ...) 
#    before calling build().
func build(is_true_ant: bool, idx_head: int, _idx_body: int) -> void:
	is_true = is_true_ant
	head_index = idx_head
	#body_index = idx_body
	_apply_parts()

func _apply_parts():
	head.region_enabled = true
	body.region_enabled = true
	limbs.region_enabled = true

	head.region_rect = _calc_region(head_index, head.texture)
	#body.region_rect = Rect2i(0, 0, 32, 32)

	head.visible = true
	body.visible = true
	limbs.visible = true

func _calc_region(index: int, tex: Texture2D) -> Rect2i:
	var size = tex.get_size()
	var tile_w = 32
	return Rect2i(index * tile_w, 0, tile_w, size.y)
