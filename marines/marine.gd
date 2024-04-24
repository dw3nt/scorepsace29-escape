class_name Marine extends CharacterBody2D

const WANDER_MOVE_SPEED: float = 20
const ESCAPE_MOVE_SPEED: float = 50

enum MoveStates { WANDER, ESCAPE }

var state: MoveStates

@onready var move_character: MoveCharacter = $MoveCharacter
@onready var wander_timer: RandomTimer = $WanderTimer

func _ready() -> void:
	change_state(MoveStates.WANDER)

func change_state(new_state: MoveStates) -> void:
	match new_state:
		MoveStates.WANDER:
			move_character.move_speed = WANDER_MOVE_SPEED
			wander_timer.start()
		
		MoveStates.ESCAPE:
			move_character.move_direction = Vector2.ZERO
			move_character.move_speed = ESCAPE_MOVE_SPEED
			wander_timer.stop()
			
	state = new_state

func escape_towards(landing_pad: LandingPad) -> void:
	change_state(MoveStates.ESCAPE)
	move_character.move_direction = Vector2.RIGHT * sign(landing_pad.global_position.x - global_position.x)

func _on_random_timer_timeout() -> void:
	if state == MoveStates.WANDER:
		if move_character.move_direction == Vector2.ZERO:
			move_character.move_direction = Vector2.RIGHT * [1, -1].pick_random()
		else:
			move_character.move_direction = Vector2.ZERO

func _on_landing_pad_detect_area_entered(_area: Area2D) -> void:
	call_deferred("set_collision_mask_value", 10, true)
	change_state(MoveStates.WANDER)

func _on_player_ship_detect_body_entered(_body: Node2D) -> void:
	print('score +100')
	queue_free()
