extends Node2D

@export var jail: Jail
@export var marines_wrapper: Node2D
@export var landing_pad: LandingPad

var player_marine_in_range: bool = false
var activated: bool = false

func _ready() -> void:
	jail.jail_removed.connect(enable_marines)

func _physics_process(_delta: float) -> void:
	if player_marine_in_range && Input.is_action_just_pressed("interact") && !activated:
		if jail:
			activated = true
			jail.shrink_jail()
			
func enable_marines() -> void:
	for marine: Marine in marines_wrapper.get_children():
		marine.escape_towards(landing_pad)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_marine_in_range = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_marine_in_range = false
