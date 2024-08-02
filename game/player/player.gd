class_name Player
extends RigidBody2D

@export var move_speed: float = 500.0

@export var idle_squish_freq: float = 8.0
@export var move_squish_freq: float = 16.0
@export var dash_squish_freq: float = 32.0

@export_group("Inner Dependencies")
@export var sprite: Sprite2D

var squish_time: float = 0.0

func _process(delta: float) -> void:
	sprite.rotation_degrees = lerpf(
		sprite.rotation_degrees,
		(45.0 * linear_velocity.normalized().x) - global_rotation_degrees,
		delta * 10.0
	)
	
	#squish_time += delta
	#squish_time = fposmod(squish_time, TAU)

func squish(freq: float) -> void:
	var w_squish: float = ( sin(freq * squish_time) / 5.0 ) + 1.0
	var h_squish: float = ( sin((freq * squish_time) - PI) / 5.0 ) + 1.0
	
	sprite.scale = Vector2(
		w_squish,
		h_squish
	)

func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _on_body_entered(body: Node) -> void:
	pass


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(
		knockback
	)
