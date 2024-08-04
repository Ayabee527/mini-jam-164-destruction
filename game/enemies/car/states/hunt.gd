extends EnemyCarState

@export var min_turn_cooldown: float = 3.0
@export var max_turn_cooldown: float = 6.0

@export var turn_timer: Timer

var target_dir: Vector2 = Vector2.ZERO
var hunt_limit: float = 64.0

func enter(_msg:={}) -> void:
	if is_instance_valid(enemy.arena):
		hunt_limit = enemy.arena.radius * 0.5
	
	target_dir = Vector2.from_angle(enemy.global_rotation)
	turn_timer.start( randf_range(min_turn_cooldown, max_turn_cooldown) )

func physics_update(delta: float) -> void:
	var steer_angle = Vector2.from_angle(enemy.global_rotation).angle_to(target_dir)
	enemy.apply_torque(
		sign(steer_angle) * enemy.turn_speed
	)
	
	var move_dir: Vector2 = Vector2.from_angle(enemy.global_rotation)
	enemy.apply_central_force(
		move_dir * enemy.hunt_speed
	)

func _on_car_finder_body_entered(body: Node2D) -> void:
	if is_active:
		if "health" in body:
			var health = body.health as Health
			if health.health <= 0:
				return
		
		if body is Player:
			state_machine.transition_to("Chase", {"target": body})
		else:
			if randf() <= 0.25:
				state_machine.transition_to("Chase", {"target": body})


func _on_turn_timer_timeout() -> void:
	if is_active:
		var center_chance: float = enemy.global_position.distance_to(Vector2.ZERO) / hunt_limit
		if randf() <= center_chance:
			target_dir = enemy.global_position.direction_to(Vector2.ZERO)
		else:
			target_dir = Vector2.from_angle(randf() * TAU)
		
		turn_timer.start( randf_range(min_turn_cooldown, max_turn_cooldown) )
