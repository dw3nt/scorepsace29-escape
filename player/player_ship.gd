extends CharacterBody2D

const SHIP_BULLET = preload("res://player/ship_bullet.tscn")

@export var max_move_speed: float = 150
@export var accel: float = 0.05
@export var friction: float = 0.01

var can_shoot: bool = true
var init_sprite_offset: Vector2

@onready var bullet_spawn_marker: Marker2D = $CollisionPolygon2D/BulletSpawnMarker
@onready var ship_bullet_cooldown: Timer = $ShipBulletCooldown
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	init_sprite_offset = sprite.offset

func _physics_process(_delta: float) -> void:
	aim_ship_at_cursor()
	calculate_ship_velocity()
	shoot_bullet()
	
	move_and_slide()
	
func aim_ship_at_cursor() -> void:
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	sprite.flip_v = mouse_position.x < global_position.x
	sprite.offset.y = init_sprite_offset.y * (-1 if mouse_position.x < global_position.x else 1)
	
func calculate_ship_velocity() -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction == Vector2.ZERO:
		velocity += (max_move_speed * friction) * (velocity.normalized() * -1)
	else:
		velocity += (max_move_speed * accel) * input_direction
		
	velocity = velocity.limit_length(max_move_speed)
	
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
