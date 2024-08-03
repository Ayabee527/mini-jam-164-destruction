class_name EnemyCar
extends RigidBody2D

@export var hunt_speed: float = 500.0
@export var chase_speed: float = 700.0
@export var turn_speed: float = 600.0

@export var squish_freq: float = 16.0

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var shadow: Shadow
@export var dirt_trail_1: GPUParticles2D
@export var dirt_trail_2: GPUParticles2D
@export var rear_1: Marker2D
@export var rear_2: Marker2D
@export var hard_hitbox_collision: CollisionShape2D
@export var soft_hitbox_collision: CollisionShape2D
@export var collision: CollisionShape2D
@export var hurtbox_collision: CollisionShape2D
@export var hurt_player: AnimationPlayer
@export var health: Health
@export var smoke_particles: GPUParticles2D

var squish_time: float = 0.0

func _ready() -> void:
	global_rotation = randf() * TAU
	
	var sprite_index: int = randi() % sprite.hframes
	sprite.frame = sprite_index
	shadow.frame = sprite_index

func _process(delta: float) -> void:
	var w_squish: float = ( sin(squish_freq * squish_time) / 10.0 ) + 1.0
	var h_squish: float = ( sin((squish_freq * squish_time) - PI) / 10.0 ) + 1.0
	
	sprite.scale = Vector2(
		w_squish,
		h_squish
	)
	shadow.shadow_scale = sprite.scale
	
	squish_time += delta
	squish_time = fposmod(squish_time, TAU)

func _on_health_was_hurt(new_health: int, amount: int) -> void:
	#print(new_health)
	hurt_player.play("hurt")
	
	if health.get_health_percent() <= 0.25:
		smoke_particles.emitting = true


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(
		knockback
	)
