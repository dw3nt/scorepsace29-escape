class_name MoveInput extends Node

@export var node2d: MoveNode2D = null
@export var character: MoveCharacter = null

var move_node: Node

func _ready() -> void:
	if node2d: move_node = node2d
	elif character: move_node = character

func _physics_process(_delta: float) -> void:
	move_node.move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
