extends Node2D

const ENEMY_CAR = preload("res://enemies/car/enemy_car.tscn")

func _ready() -> void:
	for i: int in range(50):
		var car = ENEMY_CAR.instantiate()
		car.global_position = Vector2(
			randf_range(-224, 224),
			randf_range(-224, 224),
		)
		add_child(car)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and OS.is_debug_build():
		get_tree().reload_current_scene()
