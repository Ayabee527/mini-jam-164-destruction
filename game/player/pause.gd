extends RichTextLabel

func _process(delta: float) -> void:
	global_position = get_parent().global_position - size/2
	global_position.y -= 24
	rotation = -get_parent().global_rotation
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
