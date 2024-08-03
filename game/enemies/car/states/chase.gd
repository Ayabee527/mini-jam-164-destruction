extends EnemyCarState

@export var give_up_timer: Timer
@export var reverse_timer: Timer
@export var wall_sensors: Node2D

var target: Node2D

func enter(msg:={}) -> void:
	if msg.has("target"):
		target = msg["target"]
	else:
		return

func physics_update(delta: float) -> void:
	var move_dir: Vector2 = Vector2.from_angle(enemy.global_rotation)
	var wall_avoidance := get_wall_avoidance().normalized()
	var wall_angle = Vector2.from_angle(enemy.global_rotation).angle_to(wall_avoidance)
	enemy.apply_torque(
		enemy.turn_speed * sign(wall_angle)
	)
	if wall_avoidance.length() > 0.0 and reverse_timer.is_stopped():
		reverse_timer.start()
	
	if reverse_timer.is_stopped():
		look_at_target()
		enemy.apply_central_force(
			move_dir * enemy.hunt_speed
		)
	else:
		enemy.apply_central_force(
			-move_dir * enemy.hunt_speed
		)

func exit() -> void:
	give_up_timer.stop()

func look_at_target() -> void:
	var dir_to = enemy.global_position.direction_to(target.global_position)
	var steer_angle = Vector2.from_angle(enemy.global_rotation).angle_to(dir_to)
	enemy.apply_torque(
		enemy.turn_speed * sign(steer_angle)
	)

func get_wall_avoidance() -> Vector2:
	var steer_dir: Vector2 = Vector2.ZERO
	
	for detect: RayCast2D in wall_sensors.get_children():
		if detect.is_colliding():
			for guide: RayCast2D in wall_sensors.get_children():
				if not guide.is_colliding():
					steer_dir = guide.target_position.rotated(guide.rotation + enemy.global_rotation).normalized()
					break
			break
	
	return steer_dir

func _on_car_finder_body_exited(body: Node2D) -> void:
	if body == target and is_active:
		give_up_timer.start()


func _on_give_up_timer_timeout() -> void:
	state_machine.transition_to("Hunt")


func _on_car_finder_body_entered(body: Node2D) -> void:
	if is_active and body == target:
		give_up_timer.stop()
