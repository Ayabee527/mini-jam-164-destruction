class_name Weapon
extends Node2D

@export var projectile: PackedScene
@export var active: bool = false

var firing: bool = false:
	set = set_firing

func set_firing(new_firing: bool) -> void:
	firing = new_firing
	if firing:
		shoot()

func shoot() -> void:
	pass
