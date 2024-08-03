@tool
class_name HeightSprite
extends Sprite2D

@export var height: float = 0.0

func _process(delta: float) -> void:
	offset = Vector2(0, -height).rotated(-global_rotation)
