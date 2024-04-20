extends Node2D

const GUN_BULLET = preload("res://player/gun_bullet.tscn")

var can_shoot: bool = true

@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var marker_2d: Marker2D = $Sprite2D/Marker2D
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	look_at(mouse_position)
	sprite.flip_v = mouse_position.x < global_position.x
	shoot_bullet()
	
func shoot_bullet() -> void:
	if Input.is_action_pressed("shoot") && can_shoot:
		can_shoot = false
		var bullet = GUN_BULLET.instantiate()
		bullet.global_position = marker_2d.global_position
		bullet.rotation = rotation
		get_tree().current_scene.add_child(bullet)
		bullet.move_node.move_direction = (marker_2d.global_position - global_position).normalized()
		shoot_cooldown_timer.start()

func _on_shoot_cooldown_timer_timeout() -> void:
	can_shoot = true
