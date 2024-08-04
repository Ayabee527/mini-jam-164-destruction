class_name BulletSpamWeapon
extends Node2D

const BULLET = preload("res://attacks/bullet/bullet.tscn")

@export var active: bool = false:
	set = set_active
@export var spam_timer: Timer

func set_active(new_active: bool) -> void:
	active = new_active
	if active:
		spam_timer.start()
	else:
		spam_timer.stop()

func shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_position = global_position
	bullet.global_rotation = global_rotation - PI/2
	bullet.speed = 256.0
	bullet.life_time = 1.0
	get_tree().current_scene.add_child(bullet)
	
	var bullet2 = BULLET.instantiate()
	bullet2.global_position = global_position
	bullet2.global_rotation = global_rotation + PI/2
	bullet2.speed = 256.0
	bullet2.life_time = 1.0
	get_tree().current_scene.add_child(bullet2)


func _on_shoot_timer_timeout() -> void:
	shoot()
