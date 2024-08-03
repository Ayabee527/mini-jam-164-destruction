class_name Hurtbox
extends Area2D

signal hurt(hitbox: Hitbox)
signal knocked_back(knockback: Vector2)

@export_group("Outer Dependencies")
@export var health: Health

@export_group("Inner Dependencies")
@export var invinc_timer: Timer

var active_hitboxes: Array[Hitbox] = []

func _process(delta: float) -> void:
	if active_hitboxes.size() > 0:
		if invinc_timer.is_stopped():
			take_damage()

func take_damage() -> void:
	var chosen_hitbox: Hitbox = active_hitboxes.back() as Hitbox
	
	health.hurt(chosen_hitbox.damage)
	
	var knockback_dir: Vector2 = chosen_hitbox.global_position.direction_to(global_position)
	var knockback: Vector2 = knockback_dir * chosen_hitbox.knockback_strength
	knocked_back.emit(knockback)
	
	invinc_timer.start(chosen_hitbox.invinc_time)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and not active_hitboxes.has(area) and not area.owner == owner:
		area = area as Hitbox
		active_hitboxes.append(area)
		hurt.emit(area)


func _on_area_exited(area: Area2D) -> void:
	active_hitboxes.erase(area)
