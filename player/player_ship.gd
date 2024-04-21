extends CharacterBody2D

const SHIP_BULLET = preload("res://player/ship_bullet.tscn")

@export var max_move_speed: float = 150
@export var accel: float = 0.05
@export var friction: float = 0.01
@export var gravity: float = 10
@export var piloting: bool = false

var can_shoot: bool = true
var init_collision_pos: Vector2
var init_hurtbox_pos: Vector2
var init_sprite_offset: Vector2
var pilot_in_range: Node2D = null
var pilot_can_exit: bool = false

@onready var bullet_spawn_marker: Marker2D = $CollisionPolygon2D/BulletSpawnMarker
@onready var ship_bullet_cooldown: Timer = $ShipBulletCooldown
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var hurtbox: Hurtbox = $Hurtbox

func _ready() -> void:
	init_collision_pos = collision_polygon_2d.position
	init_hurtbox_pos = hurtbox.position
	init_sprite_offset = sprite.offset

func _physics_process(_delta: float) -> void:
	if piloting:
		aim_ship_at_cursor()
		calculate_ship_velocity()
		shoot_bullet()
	else:
		if !is_on_floor():
			velocity.y += gravity
		
	move_and_slide()
	
	if pilot_can_exit && piloting && Input.is_action_just_pressed("interact"):
		exit_vehicle()
	elif pilot_in_range && Input.is_action_just_pressed("interact"):
		pilot_in_range.exit_vehicle()
		enter_vehicle()
	
func aim_ship_at_cursor() -> void:
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	sprite.flip_v = mouse_position.x < global_position.x
	sprite.offset.y = init_sprite_offset.y * (-1 if mouse_position.x < global_position.x else 1)
	
	collision_polygon_2d.scale.y = -1 if mouse_position.x < global_position.x else 1
	collision_polygon_2d.position.y = init_collision_pos.y * (-1 if mouse_position.x < global_position.x else 1)
	
	hurtbox.scale.y = -1 if mouse_position.x < global_position.x else 1
	hurtbox.position.y = init_hurtbox_pos.y * (-1 if mouse_position.x < global_position.x else 1)
	
func calculate_ship_velocity() -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction == Vector2.ZERO:
		velocity += (max_move_speed * friction) * (velocity.normalized() * -1)
	else:
		velocity += (max_move_speed * accel) * input_direction
		
	velocity = velocity.limit_length(max_move_speed)
	
func enter_vehicle() -> void:
	piloting = true
	
func exit_vehicle() -> void:
	velocity = Vector2.ZERO
	piloting = false
	pilot_in_range.enter_vehicle(global_position)
	
func shoot_bullet() -> void:
	if Input.is_action_pressed("shoot") && can_shoot:
		can_shoot = false
		var bullet = SHIP_BULLET.instantiate()
		bullet.global_position = bullet_spawn_marker.global_position
		bullet.rotation = rotation
		get_tree().current_scene.add_child(bullet)
		bullet.move_node.move_direction = (bullet_spawn_marker.global_position - global_position).normalized()
		ship_bullet_cooldown.start()

func _on_ship_bullet_cooldown_timeout() -> void:
	can_shoot = true

func _on_player_detect_body_entered(body: Node2D) -> void:
	pilot_in_range = body

func _on_player_detect_body_exited(_body: Node2D) -> void:
	if !piloting:
		pilot_in_range = null
