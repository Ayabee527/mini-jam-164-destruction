class_name Hitbox
extends Area2D

signal hit(hurtbox: Hurtbox)

@export var damage: int = 1
@export var invinc_time: float = 0.5
@export var knockback_strength: float = 32.0


func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area = area as Hurtbox
		hit.emit(area)
