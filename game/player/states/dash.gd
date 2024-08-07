extends PlayerState

@export var cooldown: float = 0.5
@export var dash_timer: Timer

func enter(_msg:={}) -> void:
	player.apply_central_impulse(
		Vector2.from_angle(player.global_rotation)
		* player.move_speed * 0.5
	)
	dash_timer.start(cooldown)
	player.dash_sound.play()
	
	#jump()
	
	player.hard_hitbox_collision.set_deferred("disabled", false)

func update(delta: float) -> void:
	player.squish(player.dash_squish_freq)

func physics_update(delta: float) -> void:
	var turn_axis: float = player.get_turn_axis()
	player.apply_torque(
		turn_axis * player.turn_speed * 1.0
	)
	
	var move_axis: float = player.get_move_axis()
	var move_dir: Vector2 = Vector2.from_angle(player.global_rotation)
	player.apply_central_force(
		move_dir * move_axis * player.move_speed * 1.25
	)

func exit() -> void:
	player.hard_hitbox_collision.set_deferred("disabled", true)

func jump() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		player.sprite, "offset",
		Vector2(0, -8).rotated(-player.global_rotation), 0.2
	).from(Vector2.ZERO)
	tween.tween_property(
		player.sprite, "offset",
		player.sprite.offset, 0.25
	)
	tween.tween_property(
		player.sprite, "offset",
		Vector2.ZERO, 0.05
	)
	#tween.play()

func _on_dash_timer_timeout() -> void:
	if not is_active:
		return
	
	if player.get_move_axis():
		state_machine.transition_to("Move")
	else:
		state_machine.transition_to("Idle")
