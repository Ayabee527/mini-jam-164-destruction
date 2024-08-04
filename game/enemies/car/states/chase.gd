extends EnemyCarState

@export var give_up_timer: Timer
@export var dash_timer: Timer

var target: Node2D

func enter(msg:={}) -> void:
	if msg.has("target"):
		target = msg["target"]
	else:
		return
	
	dash_timer.start()

func physics_update(delta: float) -> void:
	look_at_target()
	
	var move_dir: Vector2 = Vector2.from_angle(enemy.global_rotation)
	enemy.apply_central_force(
		move_dir * enemy.chase_speed
	)
	
	if enemy.global_position.distance_to(Vector2.ZERO) >= 192.0:
		state_machine.transition_to("Hunt")

func exit() -> void:
	give_up_timer.stop()
	dash_timer.stop()

func look_at_target() -> void:
	var dir_to = enemy.global_position.direction_to(target.global_position)
	var steer_angle = Vector2.from_angle(enemy.global_rotation).angle_to(dir_to)
	enemy.apply_torque(
		enemy.turn_speed * sign(steer_angle)
	)

func _on_car_finder_body_exited(body: Node2D) -> void:
	if body == target and is_active:
		give_up_timer.start()


func _on_give_up_timer_timeout() -> void:
	state_machine.transition_to("Hunt")


func _on_car_finder_body_entered(body: Node2D) -> void:
	if is_active:
		give_up_timer.stop()
		if body is Player and body != target:
			if randf_range(0.0, 100.0) >= enemy.health.get_health_percent():
				state_machine.transition_to("Chase", {"target": body})


func _on_dash_timer_timeout() -> void:
	if is_active:
		state_machine.transition_to("Dash", {"target": target})
