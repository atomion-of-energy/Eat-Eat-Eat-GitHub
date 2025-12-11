extends Node2D
class_name CollectableManager

const BAG_OF_COIN = preload("res://Scenes/Collectable Scenes/bag_of_coin_collectable.tscn")
const BATTERY = preload("res://Scenes/Collectable Scenes/battery_collectable.tscn")
const COIN = preload("res://Scenes/Collectable Scenes/coin_collectable.tscn")
const FISH_FOOD = preload("res://Scenes/Collectable Scenes/fish_food_collectable.tscn")
const TREASURE = preload("res://Scenes/Collectable Scenes/treasure_collectable.tscn")

@export var loot_timer : Timer

func _ready() -> void:
	GameManager.toggle_game_state.connect(toggle_collectable_spawn)

func toggle_collectable_spawn(STATE):
	if STATE == "PAUSE":
		loot_timer.stop()
		_clear_field()
	if STATE == "CONTINUE":
		loot_timer.start()

func _clear_field():
	for child in get_children():
		child.queue_free()

func _on_loot_timer_timeout() -> void:
	spawn_loot()

func spawn_loot():
	var x_pos = randi_range(0,GameManager.world_size.x)
	var random_loot = [COIN,FISH_FOOD,BATTERY,TREASURE,BAG_OF_COIN].pick_random()
	var instance = random_loot.instantiate()
	add_child(instance)
	instance.position = Vector2(x_pos,0)
