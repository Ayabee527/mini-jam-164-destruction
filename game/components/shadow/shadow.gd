class_name Shadow
extends Sprite2D

@export var caster: Sprite2D:
	set = set_caster
@export var shadow_offset: Vector2 = Vector2(-2, 2)

func _process(delta: float) -> void:
	offset = shadow_offset.rotated(-global_rotation)

func set_caster(new_caster: Sprite2D) -> void:
	caster = new_caster
	texture = caster.texture
