@tool
class_name HeightSprite
extends Sprite2D

@export var height: float = 0.0:
	set = set_height
@export var bounce: float = 0.0

var jump_velocity : float = 0.0
var jump_gravity : float = 0.0
var fall_gravity : float = 0.0

var speed: float = 0.0

func _process(delta: float) -> void:
	self.height -= speed * delta
	
	if height <= 0:
		speed *= -bounce
		height = max(0.0, height)
	
	if not is_zero_approx(speed) and height > 0.0:
		speed += get_gravity() * delta

func set_height(new_height: float) -> void:
	height = new_height
	offset = Vector2(0, -height).rotated(-global_rotation)

func get_gravity() -> float:
	return jump_gravity if speed <= 0.0 else fall_gravity

func jump(jump_height: float, jump_time_to_peak: float, jump_time_to_fall: float) -> void:
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
	
	speed = jump_velocity
