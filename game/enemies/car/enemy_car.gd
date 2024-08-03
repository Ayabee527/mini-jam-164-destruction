class_name EnemyCar
extends RigidBody2D

@export var hunt_speed: float = 500.0
@export var chase_speed: float = 800.0
@export var turn_speed: float = 600.0

@export var idle_squish_freq: float = 8.0
@export var move_squish_freq: float = 16.0
@export var dash_squish_freq: float = 32.0

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var shadow: Shadow
@export var dirt_trail_1: GPUParticles2D
@export var dirt_trail_2: GPUParticles2D
@export var rear_1: Marker2D
@export var rear_2: Marker2D
@export var hard_hitbox_collision: CollisionShape2D
@export var soft_hitbox_collision: CollisionShape2D
@export var hurt_player: AnimationPlayer

func _ready() -> void:
	global_rotation = randf() * TAU
	
	var sprite_index: int = randi() % sprite.hframes
	sprite.frame = sprite_index
	shadow.frame = sprite_index


func _on_health_was_hurt(new_health: int, amount: int) -> void:
	hurt_player.play("hurt")
