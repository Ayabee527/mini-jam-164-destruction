class_name EnemyCarState
extends State

var enemy: EnemyCar

func _ready() -> void:
	await owner.ready
	enemy = owner as EnemyCar
	assert(enemy != null)
