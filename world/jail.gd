class_name Jail extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

func shrink_jail() -> void:
	anim.play("shrink")
	
func remove_area2d() -> void:
	area_2d.queue_free()
