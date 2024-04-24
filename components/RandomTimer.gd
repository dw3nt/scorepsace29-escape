class_name RandomTimer extends Timer

@export var min_timeout: float
@export var max_timeout: float
@export var automatically_start = false
@export var only_timeout_once: bool = false

func _ready() -> void:
	autostart = automatically_start
	one_shot = only_timeout_once
	
@warning_ignore("native_method_override")
func start(time_sec: float = -1) -> void:
	var duration: float = time_sec if time_sec > 0 else randf_range(min_timeout, max_timeout)
	super.start(duration)
