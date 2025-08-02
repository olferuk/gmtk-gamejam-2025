extends Node2D
class_name InteractionComponent

signal interaction_started
signal interaction_ended

@export var interaction_enabled: bool = true
@export var interaction_offset: Vector2 = Vector2(0, -48)

@onready var interaction_indicator: Sprite2D = $InteractionIndicator

var is_player_in_range: bool = false

func _ready() -> void:
	if interaction_indicator:
		interaction_indicator.visible = false

func set_player_in_range(player_in_range: bool) -> void:
	if is_player_in_range == player_in_range:
		return

	is_player_in_range = player_in_range

	if interaction_indicator:
		interaction_indicator.visible = is_player_in_range and interaction_enabled

func interact() -> void:
	if not interaction_enabled or not is_player_in_range:
		return

	interaction_started.emit()
	print("Interaction with ", get_parent().name)

func enable_interaction() -> void:
	interaction_enabled = true
	if interaction_indicator and is_player_in_range:
		interaction_indicator.visible = true

func disable_interaction() -> void:
	interaction_enabled = false
	if interaction_indicator:
		interaction_indicator.visible = false