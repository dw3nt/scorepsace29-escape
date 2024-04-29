extends Node2D

var target: Node2D

func _process(_delta: float) -> void:
	if target:
		look_at(target.global_position)
		
	# tween back and forth along X
	# sin wave for Y
		
func target_is_piloted(target: Node) -> bool:
	return (target is PlayerMarine && target.piloting) || (target is PlayerShip && target.piloting)
		
func get_random_target() -> void:
	var targetables: Array[Node] = get_tree().get_nodes_in_group("enemy_targetable")
	target = targetables.pick_random()
	if !target_is_piloted(target):
		targetables.erase(target)
		
	return targetables.pick_random()

func _on_random_timer_timeout() -> void:
	print('fire!')
	get_random_target()
