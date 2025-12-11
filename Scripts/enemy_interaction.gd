extends Area2D
class_name EnemyInteraction

@onready var parent = get_parent()

var size : float

func _ready():
	size = parent.size
