class_name Hitbox extends Area2D

signal hurtbox_hit(hurtbox: Hurtbox)

@export var damage: float = 1.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: Hurtbox) -> void:
	hurtbox_hit.emit(hurtbox)
	hurtbox.hurtbox_hit.emit(self)
