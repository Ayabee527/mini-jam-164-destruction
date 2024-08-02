class_name DynamiteAttack
extends RigidBody2D

@export var speed: float = 256.0
@export var fuse_time: float = 1.0
@export var radius: float = 64.0

@export_group("Inner Dependencies")
@export var sprite: Sprite2D
@export var smoke: GPUParticles2D
@export var coll_shape: CollisionShape2D
@export var explosion: ExplosionAttack

func _ready() -> void:
	explosion.radius = radius
	explosion.fuse_time = fuse_time
	explosion.prepare()
	explosion.start_fuse()
	
	apply_central_impulse(
		Vector2.from_angle(global_rotation)
		* speed
	)
	angular_velocity = randf_range(-90.0, 90.0)
	print(angular_velocity)


func _on_explosion_exploded() -> void:
	set_deferred("freeze", true)
	sprite.hide()
	smoke.emitting = false


func _on_explosion_tree_exited() -> void:
	queue_free()


func _on_collide_timer_timeout() -> void:
	coll_shape.set_deferred("disabled", false)
