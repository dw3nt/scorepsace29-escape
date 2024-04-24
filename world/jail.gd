class_name Jail extends Node2D

signal jail_removed

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var wall_left: StaticBody2D = $Sprite2D/WallLeft
@onready var wall_right: StaticBody2D = $Sprite2D/WallRight

func shrink_jail() -> void:
	anim.play("shrink")
	
func remove_area2d() -> void:
	area_2d.queue_free()
	wall_left.queue_free()
	wall_right.queue_free()
	jail_removed.emit()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	#queue_free()
	pass
