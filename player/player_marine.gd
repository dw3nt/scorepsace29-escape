extends CharacterBody2D

@export var move_speed: float = 100
@export var gravity: float = 10
@export var jump_force: float = 150

func _physics_process(_delta: float) -> void:
	var horizontal_input: float = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_input * move_speed
	
	if Input.is_action_just_pressed("move_up"):
		velocity.y = -jump_force
		
	if !is_on_floor():
		velocity.y += gravity
	
	move_and_slide()
