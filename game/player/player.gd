class_name Player
extends RigidBody2D

@export var move_speed: float = 500.0
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
@export var health: Health
@export var smoke_particles: GPUParticles2D

@export var dash_sound: AudioStreamPlayer2D
@export var hurt_sound: AudioStreamPlayer2D
@export var drive_sound: AudioStreamPlayer2D

var squish_time: float = 0.0

func _ready() -> void:
	MainCam.target = self

func _process(delta: float) -> void:
	drive_sound.pitch_scale = linear_velocity.length() / (move_speed * 0.5)
	
	squish_time += delta
	squish_time = fposmod(squish_time, TAU)

func squish(freq: float) -> void:
	var w_squish: float = ( sin(freq * squish_time) / 10.0 ) + 1.0
	var h_squish: float = ( sin((freq * squish_time) - PI) / 10.0 ) + 1.0
	
	sprite.scale = Vector2(
		w_squish,
		h_squish
	)
	shadow.shadow_scale = sprite.scale

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


func _on_health_was_hurt(new_health: int, amount: int) -> void:
	MainCam.shake(5 * amount, 10, 5)
	hurt_player.play("hurt")
	hurt_sound.play()
	
	if health.get_health_percent() <= 0.25:
		smoke_particles.emitting = true
