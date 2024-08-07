class_name ExplosionAttack
extends Node2D

signal exploded()

@export var autostart: bool = true
@export var color: Color = Color(0.593, 0.419, 0)
@export var radius: float = 64.0
@export var fuse_time: float = 1.0
@export var damage: int = 1
@export var invinc_time: float = 0.5
@export var knockback: float = 512

@export_group("Inner Dependencies")
@export var preview: Polygon2D
@export var progress: Polygon2D
@export var shape: Polygon2D
@export var explode_timer: Timer
@export var hitbox: Hitbox
@export var coll_shape: CollisionShape2D
@export var debri: GPUParticles2D
@export var smoke: GPUParticles2D
@export var damage_sprite: Sprite2D
@export var explode_sound: AudioStreamPlayer2D

var boomed: bool = false
var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	damage_sprite.frame = randi() % damage_sprite.hframes
	damage_sprite.scale = Vector2.ONE * ( radius / 128.0 )
	
	prepare()
	if autostart:
		start_fuse()

func prepare() -> void:
	hitbox.damage = damage
	hitbox.invinc_time = invinc_time
	hitbox.knockback_strength = knockback
	
	progress.color = color
	preview.color = color
	shape.color = color
	
	debri.modulate = color
	
	var detail: int = 12
	var draw_points := PackedVector2Array()
	for i: int in range(detail):
		var ang = (float(i) / detail) * TAU
		var point = Vector2.from_angle(ang) * radius
		draw_points.append(point)
	
	preview.polygon = draw_points
	progress.polygon = draw_points
	shape.polygon = draw_points
	
	progress.scale = Vector2.ZERO
	shape.scale = Vector2.ZERO
	
	var col_shape := CircleShape2D.new()
	col_shape.radius = radius
	coll_shape.shape = col_shape

func start_fuse() -> void:
	if fuse_time <= 0.0:
		explode()
		return
	
	explode_timer.start(fuse_time)
	var progress_tween = create_tween()
	progress_tween.tween_property(
		progress, "scale",
		Vector2.ONE, fuse_time
	).from(Vector2.ZERO)

func explode() -> void:
	if boomed:
		return
	
	explode_sound.play()
	var dist_ratio = radius / global_position.distance_to(player.global_position) + 0.1
	MainCam.shake(30 * dist_ratio, 10, 5)
	boomed = true
	explode_timer.stop()
	coll_shape.set_deferred("disabled", false)
	preview.hide()
	progress.hide()
	
	exploded.emit()
	
	debri.restart()
	smoke.restart()
	
	var fade_time: float = 0.5
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "scale",
		Vector2.ZERO, fade_time
	).from(Vector2.ONE)
	tween.tween_property(
		hitbox, "scale",
		Vector2.ZERO, fade_time
	).from(Vector2.ONE)
	tween.play()
	
	damage_sprite.show()
	remove_child(damage_sprite)
	get_tree().current_scene.add_child(damage_sprite)
	damage_sprite.global_position = global_position
	
	await tween.finished
	coll_shape.set_deferred("disabled", true)
	
	await smoke.finished
	queue_free()

func _on_explode_timer_timeout() -> void:
	explode()
