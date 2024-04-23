extends Node2D

@export var jail: Jail

var marine_in_range: bool = false

func _physics_process(_delta: float) -> void:
	if marine_in_range && Input.is_action_just_pressed("interact"):
		if jail:
			jail.shrink_jail()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	marine_in_range = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	marine_in_range = false
