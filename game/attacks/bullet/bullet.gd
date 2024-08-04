class_name Bullet
extends RigidBody2D

@export var speed: float = 300.0
@export var life_time: float = 1.0
@export var damage: int = 5

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var shadow: Shadow
@export var anim_player: AnimationPlayer
@export var hitbox: Hitbox
@export var hit_collision: CollisionShape2D
@export var collision: CollisionShape2D
@export var life_timer: Timer

func _ready() -> void:
	hitbox.damage = damage
	
	apply_central_impulse(
		Vector2.from_angle(global_rotation)
		* speed
	)
	
	life_timer.start(life_time)


func _on_life_timer_timeout() -> void:
	linear_damp = 5.0
	hit_collision.set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
	anim_player.play("flash_out")


func _on_activate_timer_timeout() -> void:
	hit_collision.set_deferred("disabled", false)
	collision.set_deferred("disabled", false)
