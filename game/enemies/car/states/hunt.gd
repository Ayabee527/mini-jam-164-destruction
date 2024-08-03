extends EnemyCarState

@export var min_turn_cooldown: float = 3.0
@export var max_turn_cooldown: float = 6.0

@export var turn_timer: Timer
@export var reverse_timer: Timer
@export var wall_sensors: Node2D

func enter(_msg:={}) -> void:
	turn_timer.start( randf_range(min_turn_cooldown, max_turn_cooldown) )

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
		enemy.apply_central_force(
			move_dir * enemy.hunt_speed
		)
	else:
		enemy.apply_central_force(
			-move_dir * enemy.hunt_speed
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

func _on_car_finder_body_entered(body: Node2D) -> void:
	if is_active:
		state_machine.transition_to("Chase", {"target": body})


func _on_turn_timer_timeout() -> void:
	if is_active:
		enemy.apply_torque_impulse(
			randf_range(-720, 720)
		)
		
		turn_timer.start( randf_range(min_turn_cooldown, max_turn_cooldown) )
