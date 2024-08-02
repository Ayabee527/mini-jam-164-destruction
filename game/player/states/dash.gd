extends PlayerState


@export var cooldown: float = 0.5
@export var dash_timer: Timer

func enter(_msg:={}) -> void:
	player.apply_central_impulse(
		player.get_move_vector()
		* player.move_speed * 0.75
	)
	dash_timer.start(cooldown)

func update(delta: float) -> void:
	player.squish(player.dash_squish_freq)

func exit() -> void:
	pass

func _on_dash_timer_timeout() -> void:
	if not is_active:
		return
	
	if player.get_move_vector():
		state_machine.transition_to("Fly")
	else:
		state_machine.transition_to("Idle")
