class_name SkidMark
extends Line2D

@export var color: Color = Color(0.593, 0.419, 0)

@export var length: int = 64.0

var detached: bool = false

func _ready() -> void:
	modulate = color

func _process(delta: float) -> void:
	global_position = Vector2.ZERO
	global_rotation = 0
	global_scale = Vector2.ONE
	
	if detached:
		return
	
	add_point( get_parent().global_position )

func detach() -> void:
	detached = true
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(
		self,"width",
		0.0, 10.0
	)
	await tween.finished
	queue_free()
