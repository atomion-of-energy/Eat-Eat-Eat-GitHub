extends CharacterBody2D
class_name EnemyFish

@onready var movement_timer: Timer = $"Movement Timer"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sight_range_collision: CollisionShape2D = $SightRange/SightRangeCollision
@onready var sight_range: Area2D = $SightRange

@export var player_stats : PlayerStats

var speed : int = 80
var chasing_speed : int = 120
var dir : Vector2
var size : float = 1
var player : CharacterBody2D = null
var STATE : String = " "

func _ready() -> void:
	size = snappedf(randf_range(0.2,player_stats.size + 0.60),0.20)
	if size < 0:
		size = 0.25
	scale *= size
	$Label.text = str(size)
	dir = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	velocity = dir * speed

func _physics_process(delta: float) -> void:
	if STATE == "predator":
		chasing()
	if STATE == "prey":
		fleeing()
	move_and_slide()
	animation_manager(dir)

func _on_movement_timer_timeout() -> void:
	if STATE == "roaming":
		$"Movement Timer".wait_time = [3,4,5].pick_random()
		dir = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
		velocity = dir * speed * size

func animation_manager(dir):
	if dir.x < 0:
		sprite_2d.flip_h = false
	elif dir.x > 0:
		sprite_2d.flip_h = true

func chasing():
	if player:
		dir = position.direction_to(player.position).normalized()
		velocity = dir * chasing_speed * size

func fleeing():
	if player:
		dir = player.position.direction_to(position).normalized()
		velocity = dir * chasing_speed * size

func _on_sight_range_body_entered(body: CharacterBody2D) -> void:
	player = body
	movement_timer.stop()
	if player_stats.size >= size:
		STATE = "prey"
	else:
		STATE = "predator"

func _on_sight_range_body_exited(body: CharacterBody2D) -> void:
	player = null
	STATE = "roaming"
	movement_timer.start()
	dir = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	velocity = dir * speed * size
	
