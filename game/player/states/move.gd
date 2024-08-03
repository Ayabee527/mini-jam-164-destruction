extends PlayerState

func enter(_msg:={}) -> void:
	pass

func update(delta: float) -> void:
	player.squish(player.move_squish_freq)

func physics_update(delta: float) -> void:
	var move_axis: float = player.get_move_axis()
	var move_dir: Vector2 = Vector2.from_angle(player.global_rotation)
	
	var turn_axis: float = player.get_turn_axis()
	player.apply_torque(
		turn_axis * player.turn_speed
	)
	
	player.apply_central_force(
		move_dir * move_axis * player.move_speed
	)
	
	if not move_axis:
		state_machine.transition_to("Idle")
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")

func exit() -> void:
	pass
