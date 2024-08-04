class_name DynaTurnWeapon
extends Node2D

const DYNAMITE = preload("res://attacks/dynamite/dynamite.tscn")

@export var active: bool = false
@export var car: EnemyCar

var has_shot: bool = false

func _process(delta: float) -> void:
	if not active:
		return
	
	if abs(car.angular_velocity) > 3.0 and not has_shot:
		shoot()
	
	if abs(car.angular_velocity) < 3.0 and has_shot:
		has_shot = false

func shoot() -> void:
	has_shot = true
	var dyna = DYNAMITE.instantiate()
	dyna.global_position = global_position
	dyna.global_rotation = randf() * TAU
	dyna.speed = randf_range(64, 192)
	dyna.radius = randf_range(16, 48)
	get_tree().current_scene.add_child(dyna)
