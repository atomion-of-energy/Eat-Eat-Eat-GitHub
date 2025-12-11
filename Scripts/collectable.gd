extends RigidBody2D
class_name Collectable

@export var cash_amount : int = 0
@export var energy_amount : int = 0
@export var heal_amount : int = 0
@export_enum("Cash","Energy","Food") var type : String

func _on_timer_timeout() -> void:
	queue_free()
