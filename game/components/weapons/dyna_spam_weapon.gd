class_name DynaSpamWeapon
extends Node2D

const DYNAMITE = preload("res://attacks/dynamite/dynamite.tscn")

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
	var dyna = DYNAMITE.instantiate()
	dyna.global_position = global_position
	dyna.global_rotation = randf() * TAU
	dyna.speed = randf_range(64, 192)
	dyna.radius = randf_range(16, 48)
	get_tree().current_scene.add_child(dyna)

func _on_spam_timer_timeout() -> void:
	shoot()
