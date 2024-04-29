class_name PlayerMarine extends CharacterBody2D

@export var move_speed: float = 100
@export var gravity: float = 10
@export var jump_force: float = 150
@export var piloting: bool = true

@onready var gun: Node2D = $Gun

func _physics_process(_delta: float) -> void:
	if piloting:
		calculate_horizontal_velocity()
		calculate_vertical_velocity()
		move_and_slide()
	
func calculate_horizontal_velocity() -> void:
	var horizontal_input: float = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_input * move_speed
	
func calculate_vertical_velocity() -> void:
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
		
	if !is_on_floor():
		velocity.y += gravity
		
func enter_vehicle(pos: Vector2) -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	await get_tree().process_frame
	piloting = true
	visible = true
	global_position = pos
	
func exit_vehicle() -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	await get_tree().process_frame
	piloting = false
	visible = false
