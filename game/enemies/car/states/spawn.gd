extends EnemyCarState

@export var start_time: float = 3.0
@export var start_timer: Timer

func enter(_msg:={}) -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		enemy, "modulate:a",
		1.0, start_time
	).from(0.0)
	tween.tween_property(
		enemy.shadow, "color",
		Color(0, 0, 0, 1.0), start_time
	).from(Color(0, 0, 0, 0.0))
	tween.play()
	
	start_timer.start(start_time)


func _on_start_timer_timeout() -> void:
	enemy.dirt_trail_1.emitting = true
	enemy.dirt_trail_2.emitting = true
	
	enemy.soft_hitbox_collision.set_deferred("disabled", false)
	enemy.hurtbox_collision.set_deferred("disabled", false)
	
	if enemy.sprite.frame == 4:
		enemy.dyna_spam.active = true
	if enemy.sprite.frame == 5:
		enemy.bullet_spam.active = true
	
	state_machine.transition_to("Hunt")
