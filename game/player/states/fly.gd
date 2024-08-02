extends PlayerState

func update(delta: float) -> void:
	player.squish(player.move_squish_freq)

func physics_update(delta: float) -> void:
	var move_dir: Vector2 = player.get_move_vector()
	
	player.apply_central_force(
		move_dir * player.move_speed
	)
	
	if not move_dir:
		state_machine.transition_to("Idle")
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
