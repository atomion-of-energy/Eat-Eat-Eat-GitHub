extends Node2D
class_name EnemyManager

@export var enemies : Dictionary[String,PackedScene]
@onready var player_fish: PlayerFish = $"../Player_Fish"
@onready var enemy_spawn_timer: Timer = $"../EnemySpawnTimer"

var children : int = 0

func _ready() -> void:
	GameManager.toggle_game_state.connect(toggle_enemy_spawn)

func _process(delta: float) -> void:
	color_grade_fishes()

func get_num_of_enemies():
	children = get_child_count()
	GameManager._enemy_label(children)

func toggle_enemy_spawn(STATE):
	if STATE == "PAUSE":
		enemy_spawn_timer.stop()
		clear_field()
	if STATE == "CONTINUE":
		enemy_spawn_timer.start()

func clear_field():
	for child in get_children():
		child.queue_free()
	get_num_of_enemies()

func out_of_bound():
	for child in get_children():
		var distance = child.position.distance_to(player_fish.position)
		if distance > 1500:
			child.queue_free()

func _on_enemy_spawn_timer_timeout() -> void:
	if children >= 75:
		return
	if enemies.has("fish"):
		var instance = enemies["fish"].instantiate()
		add_child(instance)
		instance.position = generate_randi_enemy_pos()
		get_num_of_enemies()

func generate_randi_enemy_pos() -> Vector2i:
	if randi() % 2 == 0:
		var x = (randi_range(15,20)) * [-1,1].pick_random()
		var y = (randi_range(0,15)) * [-1,1].pick_random()
		return player_fish.position + (Vector2(x,y) * 64)
	else:
		var x = (randi_range(0,20)) * [-1,1].pick_random()
		var y = (randi_range(10,15)) * [-1,1].pick_random()
		return player_fish.position + (Vector2(x,y) * 64)

func _on_enemy_despawn_timer_timeout() -> void:
	out_of_bound()

func color_grade_fishes():
	for child in get_children():
		if child.scale > player_fish.scale:
			child.modulate = Color(3,1,1.5,1)
		else:
			child.modulate = Color(2,2,2,1)
