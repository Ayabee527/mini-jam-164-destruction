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

@export var drive_sound: AudioStreamPlayer2D
@export var dash_sound: AudioStreamPlayer2D
@export var hurt_sound: AudioStreamPlayer2D
@export var die_sound: AudioStreamPlayer2D

@export var fortnite_timer: Timer

@export var dyna_turn: DynaTurnWeapon
@export var bullet_turn: BulletTurnWeapon
@export var bullet_hit: HitBulletWeapon
@export var dyna_spam: DynaSpamWeapon
@export var bullet_spam: BulletSpamWeapon

var squish_time: float = 0.0

var arena: Arena

func _ready() -> void:
	global_rotation = randf() * TAU
	
	var sprite_index: int = randi() % sprite.hframes
	#sprite_index = 5
	sprite.frame = sprite_index
	shadow.frame = sprite_index
	
	match sprite.frame:
		1:
			dyna_turn.active = true
		2:
			bullet_turn.active = true
		3:
			bullet_hit.active = true

func _process(delta: float) -> void:
	drive_sound.pitch_scale = max( 0.1, linear_velocity.length() / (hunt_speed * 0.5) )
	
	var w_squish: float = ( sin(squish_freq * squish_time) / 10.0 ) + 1.0
	var h_squish: float = ( sin((squish_freq * squish_time) - PI) / 10.0 ) + 1.0
	
	sprite.scale = Vector2(
		w_squish,
		h_squish
	)
	shadow.shadow_scale = sprite.scale
	
	if sprite.height <= 0.0:
		squish_time += delta
		squish_time = fposmod(squish_time, TAU)

func _on_health_was_hurt(new_health: int, amount: int) -> void:
	#print(new_health)
	hurt_player.play("hurt")
	hurt_sound.play()
	linear_velocity *= 0.5
	
	if health.get_health_percent() <= 25.0:
		smoke_particles.emitting = true


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(
		knockback
	)


func _on_health_has_died() -> void:
	die_sound.play()


func _on_arena_detect_area_entered(area: Area2D) -> void:
	arena = area as Arena
	fortnite_timer.stop()


func _on_arena_detect_area_exited(area: Area2D) -> void:
	fortnite_timer.start()


func _on_fortnite_timeout() -> void:
	health.hurt(1)
