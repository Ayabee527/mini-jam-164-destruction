class_name BulletTurnWeapon
extends Node2D

const BULLET = preload("res://attacks/bullet/bullet.tscn")

@export var active: bool = false
@export var car: EnemyCar
@export var shoot_timer: Timer

var firing: bool:
	set = set_firing

func _process(delta: float) -> void:
	if not active:
		return
	
	if abs(car.angular_velocity) > 3.0 and not firing:
		firing = true
	
	if abs(car.angular_velocity) < 3.0 and firing:
		firing = false

func set_firing(new_firing: bool) -> void:
	firing = new_firing
	if firing:
		shoot()

func shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_position = global_position
	bullet.global_rotation = global_rotation
	bullet.speed = 16.0
	bullet.life_time = 3.0
	get_tree().current_scene.add_child(bullet)
	shoot_timer.start()


func _on_shoot_timer_timeout() -> void:
	if firing:
		shoot()
