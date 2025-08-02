extends AntBase

class_name AntBuilder

func _ready() -> void:
	head.texture = preload("res://vfx/sprite_sheets/heads_safety.png")
	body.texture = preload("res://vfx/sprite_sheets/body_jackets.png")
	super()._ready()
