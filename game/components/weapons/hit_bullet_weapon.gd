class_name HitBulletWeapon
extends Node2D

const BULLET = preload("res://attacks/bullet/bullet.tscn")

@export var active: bool = false
@export var radius: float = 24.0
@export var bullets: int = 12
@export var health: Health

func _ready() -> void:
	health.was_hurt.connect(
		func(_new_health: int, _amount: int):
			shoot()
	)

func shoot() -> void:
	if not active:
		return
	
	for i: int in range(bullets):
		var ang = (float(i) / bullets) * TAU
		var point = Vector2.from_angle(ang) * radius
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position + point
		bullet.global_rotation = ang
		bullet.speed = 256.0
		bullet.life_time = 1.0
		get_tree().current_scene.add_child(bullet)
