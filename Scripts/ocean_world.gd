extends Node2D
class_name OceanWorld

@export var enemy_spawn_timer : Timer
@export var enemy_spawn_time: float = 0.5

func _ready() -> void:
	ProjectSettings.set_setting("physics/2d/default_gravity", -5)
	enemy_spawn_timer.wait_time = enemy_spawn_time
