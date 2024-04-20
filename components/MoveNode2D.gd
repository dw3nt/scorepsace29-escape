class_name MoveNode2D extends Node2D

@export var node2d: Node2D = null
@export var move_direction: Vector2 = Vector2.ZERO
@export var move_speed: float = 0.0

func _physics_process(delta: float) -> void:
	node2d.global_position += move_direction.normalized() * move_speed * delta
