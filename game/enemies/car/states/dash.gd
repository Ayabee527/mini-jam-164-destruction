extends EnemyCarState

@export var cooldown: float = 0.5
@export var dash_timer: Timer

var target: Node2D = null

func enter(msg:={}) -> void:
	if msg.has("target"):
		target = msg["target"]
	
	enemy.apply_central_impulse(
		Vector2.from_angle(enemy.global_rotation)
		* enemy.chase_speed * 0.5
	)
	dash_timer.start(cooldown)
	
	#jump()
	
	enemy.hard_hitbox_collision.set_deferred("disabled", false)

func physics_update(delta: float) -> void:
	if is_instance_valid(target):
		look_at_target()
	
	var move_dir: Vector2 = Vector2.from_angle(enemy.global_rotation)
	enemy.apply_central_force(
		move_dir * enemy.chase_speed * 1.25
	)

func look_at_target() -> void:
	var dir_to = enemy.global_position.direction_to(target.global_position)
	var steer_angle = Vector2.from_angle(enemy.global_rotation).angle_to(dir_to)
	enemy.apply_torque(
		enemy.turn_speed * sign(steer_angle)
	)

func exit() -> void:
	enemy.hard_hitbox_collision.set_deferred("disabled", true)
	target = null

func _on_dash_timer_timeout() -> void:
	if not is_active:
		return
	
	state_machine.transition_to("Hunt")
