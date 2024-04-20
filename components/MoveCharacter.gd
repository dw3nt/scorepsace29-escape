class_name MoveCharacter extends Node

@export var character: CharacterBody2D = null
@export var move_direction: Vector2 = Vector2.ZERO
@export var move_speed: float = 0.0

func _physics_process(_delta: float) -> void:
	character.velocity = move_direction * move_speed
	character.move_and_slide()
