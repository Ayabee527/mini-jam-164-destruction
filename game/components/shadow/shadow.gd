class_name Shadow
extends Sprite2D

@export var color: Color = Color.BLACK:
	set = set_color
@export var caster: HeightSprite:
	set = set_caster
@export var shadow_offset: Vector2 = Vector2(-2, 2)
@export var shadow_scale: Vector2 = Vector2.ONE
@export var max_height: float = 256.0
var height_scale: float = 1.0

var shadow_material: ShaderMaterial

func _ready() -> void:
	shadow_material = material

func _process(delta: float) -> void:
	offset = shadow_offset.rotated(-global_rotation)
	
	if is_instance_valid(caster):
		height_scale = max(
			0, (1 - (caster.height / max_height))
		)
	
	scale = shadow_scale * height_scale

func set_color(new_color: Color) -> void:
	color = new_color
	shadow_material.set_shader_parameter("color", color)

func set_caster(new_caster: HeightSprite) -> void:
	caster = new_caster
	texture = caster.texture
