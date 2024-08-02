extends PlayerState

func update(delta: float) -> void:
	player.squish(player.idle_squish_freq)

func physics_update(delta: float) -> void:
	if player.get_move_vector():
		state_machine.transition_to("Fly")
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
