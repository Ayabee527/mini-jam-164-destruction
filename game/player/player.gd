class_name Player
extends RigidBody2D

@export var move_speed: float = 500.0
@export var turn_speed: float = 600.0

@export var idle_squish_freq: float = 8.0
@export var move_squish_freq: float = 16.0
@export var dash_squish_freq: float = 32.0

@export_group("Inner Dependencies")
@export var sprite: Sprite2D
@export var shadow: Shadow
@export var dirt_trail_1: GPUParticles2D
@export var dirt_trail_2: GPUParticles2D

var squish_time: float = 0.0

func _ready() -> void:
	MainCam.target = self

func _process(delta: float) -> void:
	squish_time += delta
	squish_time = fposmod(squish_time, TAU)

func squish(freq: float) -> void:
	var w_squish: float = ( sin(freq * squish_time) / 10.0 ) + 1.0
	var h_squish: float = ( sin((freq * squish_time) - PI) / 10.0 ) + 1.0
	
	sprite.scale = Vector2(
		w_squish,
		h_squish
	)
	shadow.scale = sprite.scale

func get_move_axis() -> float:
	return Input.get_axis("move_back", "move_forward")

func get_turn_axis() -> float:
	return Input.get_axis("turn_left", "turn_right")

func _on_body_entered(body: Node) -> void:
	pass


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(
		knockback
	)
