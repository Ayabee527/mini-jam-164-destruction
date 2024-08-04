extends EnemyCarState

const EXPLOSION = preload("res://attacks/explosion/explosion.tscn")

var target: Node2D

func enter(msg:={}) -> void:
	if msg.has("target"):
		target = msg["target"]
	
	enemy.apply_central_impulse(
		Vector2.from_angle(enemy.global_rotation)
		* enemy.chase_speed * 0.5
	)
	
	var explosion := EXPLOSION.instantiate()
	explosion.fuse_time = 3.0
	explosion.damage = 10.0
	explosion.radius = randf_range(24, 48)
	enemy.rear_2.add_sibling(explosion)
	explosion.exploded.connect(explode)
	explosion.tree_exited.connect(
		func():
			enemy.queue_free()
	)

func physics_update(_delta: float) -> void:
	if is_instance_valid(target):
		look_at_target()
	
	var move_dir: Vector2 = Vector2.from_angle(enemy.global_rotation)
	enemy.apply_central_force(
		move_dir * enemy.hunt_speed * 0.2
	)

func look_at_target() -> void:
	var dir_to = enemy.global_position.direction_to(target.global_position)
	var steer_angle = Vector2.from_angle(enemy.global_rotation).angle_to(dir_to)
	enemy.apply_torque(
		enemy.turn_speed * sign(steer_angle)
	)

func explode() -> void:
	enemy.set_deferred("freeze", true)
	
	enemy.shadow.hide()
	enemy.sprite.hide()
	enemy.dirt_trail_1.emitting = false
	enemy.dirt_trail_1.emitting = false
	enemy.smoke_particles.emitting = false
	enemy.collision.set_deferred("disabled", true)
	enemy.hurtbox_collision.set_deferred("disabled", true)
	enemy.soft_hitbox_collision.set_deferred("disabled", true)
	enemy.hard_hitbox_collision.set_deferred("disabled", true)
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		enemy.rear_1, "modulate:a",
		0.0, 1.0
	)
	tween.tween_property(
		enemy.rear_2, "modulate:a",
		0.0, 1.0
	)
	tween.play()
	

func _on_health_has_died() -> void:
	if not is_active:
		state_machine.transition_to("Dead", {"target": get_tree().get_first_node_in_group("player")})
