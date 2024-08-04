class_name Arena
extends Area2D

@export var undu_amplitude: float = 4.0
@export var undu_frequency: float = 16.0
@export var radius: float = 256.0

@export var border: Line2D
@export var collision: CollisionShape2D

var detail: int = 128.0
var undu_time: float = 0.0

var points := PackedVector2Array()

func _ready() -> void:
	draw_border()
	
	var shape = CircleShape2D.new()
	shape.radius = radius
	collision.shape = shape

func _process(delta: float) -> void:
	var undu_points := PackedVector2Array()
	undu_points.resize(detail + 1)
	
	for i: int in range(detail):
		var sine_val: float = undu_time + ((float(i) / detail) * TAU)
		var offset: float = undu_amplitude * sin(undu_frequency * sine_val)
		
		var old_point: Vector2 = points[i]
		var new_point: Vector2 = old_point.normalized() * (radius + offset)
		undu_points[i] = new_point
	undu_points[detail] = undu_points[0]
	
	border.points = undu_points
	
	undu_time += delta
	undu_time = fposmod(undu_time, TAU)

func draw_border() -> void:
	for i: int in range(detail):
		var ang = (float(i) / detail) * TAU
		var point = Vector2.from_angle(ang) * radius
		points.append(point)
	points.append(Vector2.RIGHT * radius)
	border.points = points
