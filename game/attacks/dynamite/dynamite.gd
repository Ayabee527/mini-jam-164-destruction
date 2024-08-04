class_name DynamiteAttack
extends RigidBody2D

@export var speed: float = 128.0
@export var fuse_time: float = 1.0
@export var radius: float = 64.0
@export var damage: int = 10

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var shadow: Shadow
@export var smoke: GPUParticles2D
@export var coll_shape: CollisionShape2D
@export var explosion: ExplosionAttack
@export var fuse: Marker2D

func _ready() -> void:
	explosion.damage = damage
	explosion.radius = radius
	explosion.fuse_time = fuse_time
	explosion.prepare()
	explosion.start_fuse()
	
	apply_central_impulse(
		Vector2.from_angle(global_rotation)
		* speed
	)
	angular_velocity = randf_range(-30.0, 30.0)
	
	sprite.jump(
		64.0, fuse_time / 2.0, fuse_time / 2.0
	)

func _process(delta: float) -> void:
	fuse.position = sprite.offset + Vector2(4.0, 0).rotated(sprite.global_rotation)

func _on_explosion_exploded() -> void:
	set_deferred("freeze", true)
	sprite.hide()
	shadow.hide()
	smoke.emitting = false


func _on_explosion_tree_exited() -> void:
	queue_free()
