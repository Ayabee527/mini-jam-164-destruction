extends PlayerState

func enter(_msg:={}) -> void:
	player.dirt_trail_1.emitting = false
	player.dirt_trail_2.emitting = false

func update(delta: float) -> void:
	player.squish(player.idle_squish_freq)

func physics_update(delta: float) -> void:
	#var turn_axis: float = player.get_turn_axis()
	#player.apply_torque(
		#turn_axis * player.turn_speed
	#)
	
	if player.get_move_axis():
		state_machine.transition_to("Move")
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")

func exit() -> void:
	player.dirt_trail_1.emitting = true
	player.dirt_trail_2.emitting = true
