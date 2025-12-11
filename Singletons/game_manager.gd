extends Control

var world_size : Vector2 = Vector2(7680,4320)

@export var shop : Shop

@onready var score_label: Label = $"CanvasLayer/Info Panel/Score_Label"
@onready var highscore_label: Label = $"CanvasLayer/Info Panel/Highscore_Label"
@onready var player_stats_label: Label = $"CanvasLayer/Info Panel/PlayerStats_Label"
@onready var cash_label: Label = $CanvasLayer/TextureProgressBar/Cash_Label
@onready var largest_size_label: Label = $"CanvasLayer/Info Panel/Largest_Size_Label"

@onready var texture_progress_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var start_game: Button = $CanvasLayer/StartGame
@onready var health_drain_timer: Timer = $Health_Drain_Timer
@onready var shop_panel: Panel = $"CanvasLayer/Shop Panel"

var player_stats = preload("res://Resource/player_stats.tres")
var is_dead : bool = false
var total_score : int = 0
var highscore : int
var largest_size : float = 0.5
var max_hp : float = 100.0
var current_hp : float
var player_size : float = 1.0
var cash : float
var drain : float = 0.1

signal toggle_game_state(STATE : String)

func _ready() -> void:
	if SaveLoadSystem.SaveFileData.player_stats_data :
		await _load_player_stats(SaveLoadSystem.SaveFileData.player_stats_data)
	else:
		SaveLoadSystem.SaveFileData.player_stats_data = player_stats
	cash = SaveLoadSystem.SaveFileData.player_cash
	highscore = SaveLoadSystem.SaveFileData.player_high_score
	largest_size = SaveLoadSystem.SaveFileData.player_largest_size
	highscore_label.text = "High Score: " + str(highscore)
	largest_size_label.text = "Largest Size: " + str(largest_size)
	shop.button_levels = SaveLoadSystem.SaveFileData.button_levels
	
	texture_progress_bar.max_value = max_hp
	texture_progress_bar.value = max_hp
	current_hp = max_hp
	start_game.visible = false
	shop_panel.visible = false
	cash_label.text = "$" + str(cash)
	player_stats_label_manager()

func _process(delta: float) -> void:
	if !is_dead:
		health_drain(delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("start_game") and is_dead:
		_start_game_manager()

func death_manager():
	#this manage the reset funationality after every death event
	toggle_game_state.emit("PAUSE")
	is_dead = true
	
	drain = 0
	health_drain_timer.stop()
	
	total_score = 0
	score_label.text = "Score: " + str(total_score)
	
	start_game.visible = true
	shop_panel.visible = true
	current_hp = max_hp
	texture_progress_bar.value = max_hp
	_save_data()

func _load_player_stats(saved_player_stats : PlayerStats):
	player_stats.cash_multiplier = saved_player_stats.cash_multiplier
	player_stats.drain_factor = saved_player_stats.drain_factor
	player_stats.healing_factor = saved_player_stats.healing_factor
	player_stats.speed = saved_player_stats.speed
	player_stats.accer_factor = saved_player_stats.accer_factor
	player_stats.recharge_speed = saved_player_stats.recharge_speed

func _save_player_stats(saved_player_stats : PlayerStats):
	saved_player_stats.cash_multiplier = player_stats.cash_multiplier
	saved_player_stats.drain_factor = player_stats.drain_factor
	saved_player_stats.healing_factor = player_stats.healing_factor
	saved_player_stats.speed = player_stats.speed
	saved_player_stats.accer_factor = player_stats.accer_factor
	saved_player_stats.recharge_speed = player_stats.recharge_speed

func player_stats_label_manager():
	player_stats_label.text = "Size: " + str(snappedf(player_stats.size,0.001)) +\
	"\nLv" + str(shop.button_levels[0]) + " Cash Multi: " + str(player_stats.cash_multiplier) +\
	"\nLv" + str(shop.button_levels[1]) + " Acceleration Factor: " + str(player_stats.accer_factor) +\
	"\nLv" + str(shop.button_levels[2]) + " Speed: " + str(player_stats.speed) +\
	"\nLv" + str(shop.button_levels[3]) + " Healing Factor: " + str(player_stats.healing_factor) +\
	"\nLv" + str(shop.button_levels[4]) + " Drain Speed: " + str(player_stats.drain_factor) + "%"+\
	"\nLv" + str(shop.button_levels[5]) + " Recharge Speed: " + str(player_stats.recharge_speed)

func score_maanger(score : int):
	total_score += score
	score_label.text = "Score: " + str(total_score)

func highscore_manager(score : int):
	if highscore < score:
		highscore = score
		highscore_label.text = "High Score: " + str(highscore)

func largest_size_manager():
	var size = snappedf(player_stats.size,0.01)
	if largest_size < size:
		largest_size = size
		largest_size_label.text = "Largest Size: " + str(largest_size)

func game_over_score_label():
	$CanvasLayer/StartGame/Game_Over_Score.text = "High Score: " + str(highscore) +\
	"\nScore: " + str(total_score) +\
	"\nLargest Size: " + str(largest_size) +\
	"\nSize: " + str(snappedf(player_stats.size,0.01))

func add_cash(amount):
	cash += amount * player_stats.cash_multiplier
	cash_label.text = "$" + str(cash)

func heal(amount : float):
	current_hp += amount
	if current_hp > max_hp:
		current_hp = max_hp

func health_drain(delta):
	current_hp -= delta * drain * player_stats.drain_factor/100
	if current_hp < 0:
		death_manager()
		return
	texture_progress_bar.value = current_hp

func _on_health_drain_timer_timeout() -> void:
	drain += 0.1

func _start_game_manager():
	AudioManager.button_sfx()
	toggle_game_state.emit("CONTINUE")
	start_game.visible = false
	shop_panel.visible = false
	is_dead = false
	health_drain_timer.start()

func _on_start_game_pressed() -> void:
	_start_game_manager()

func _on_save__quit_pressed() -> void:
	_save_data()

func _save_data():
	if SaveLoadSystem.SaveFileData.player_stats_data:
		await _save_player_stats(SaveLoadSystem.SaveFileData.player_stats_data)
	SaveLoadSystem.SaveFileData.player_cash = cash
	SaveLoadSystem.SaveFileData.player_high_score = highscore
	SaveLoadSystem.SaveFileData.player_largest_size = largest_size
	SaveLoadSystem.SaveFileData.button_levels = shop.button_levels
	SaveLoadSystem._save()

func _on_new_file_pressed() -> void:
	highscore = 0
	largest_size = 0
	highscore_label.text = "High Score: " + str(highscore)
	largest_size_label.text = "Largest Size: " + str(largest_size)
	cash = 0
	cash_label.text = "$" + str(cash)
	
	SaveLoadSystem.SaveFileData.player_stats_data = player_stats
	SaveLoadSystem.SaveFileData.player_cash = cash
	SaveLoadSystem.SaveFileData.player_high_score = highscore
	SaveLoadSystem.SaveFileData.player_largest_size = largest_size
	shop.initial_button_levels()
	SaveLoadSystem.SaveFileData.button_levels = shop.button_levels
	player_stats_label_manager()
	await SaveLoadSystem._save()

func _enemy_label(amount):
	$"CanvasLayer/Info Panel/Enemy_Label".text = "Enemies: "+ str(amount)
