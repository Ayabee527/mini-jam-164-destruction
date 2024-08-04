extends Node2D

const ENEMY_CAR = preload("res://enemies/car/enemy_car.tscn")

func _ready() -> void:
	for i: int in range(10):
		var car = ENEMY_CAR.instantiate()
		car.global_position = Vector2(
			Vector2.from_angle(randf() * TAU) * 256.0
		)
		#car.global_position = Vector2(
			#randf_range(-64, 64),
			#randf_range(-64, 64),
		#)
		add_child(car)
		#await get_tree().create_timer(2.0, false).timeout

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and OS.is_debug_build():
		get_tree().reload_current_scene()
