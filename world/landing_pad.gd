extends Node2D

func _on_ship_detect_body_entered(body: Node2D) -> void:
	body.pilot_can_exit = true

func _on_ship_detect_body_exited(body: Node2D) -> void:
	body.pilot_can_exit = false
