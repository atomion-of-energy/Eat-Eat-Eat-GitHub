extends GridContainer
class_name Shop

@export var player_stats : PlayerStats

var button_costs : Dictionary = {}
var button_levels : Dictionary = {}
var stats_levels : Dictionary

func _ready() -> void:
	set_button_cost()
	initial_button_levels()
	set_stats_levels()
	button_levels = SaveLoadSystem.SaveFileData.button_levels
	for child in get_children():
		button_text_manger(child)
		child.pressed.connect(button_manager.bind(child))

func set_button_cost():
	button_costs[0] = [10,20,40,80,160,320,640,1280] #Cash Multiplier
	button_costs[1] = [10,20,40,80,160,320,640,1280] #Acceleration
	button_costs[2] = [10,20,40,80,160,320,640,1280] #Speed
	button_costs[3] = [10,20,40,80,160,320,640,1280] #Healing Factor
	button_costs[4] = [10,20,40,80,160,320,640,1280] #Drain Factor
	button_costs[5] = [10,20,40,80,160,320,640,1280] #Recharge Speed

func initial_button_levels():
	button_levels[0] = 0 #Cash Multiplier
	button_levels[1] = 0 #Acceleration
	button_levels[2] = 0 #Speed
	button_levels[3] = 0 #Healing Factor
	button_levels[4] = 0 #Drain Factor
	button_levels[5] = 0 #Recharge Speed

func set_stats_levels():
	stats_levels[0] = [1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5] #Cash Multiplier
	stats_levels[1] = [5,6,7,8,9,10,11,12,13,14] #Acceleration
	stats_levels[2] = [200,220,240,260,280,300,320,340,360,380] #Speed
	stats_levels[3] = [10,12,14,16,18,20,22,24,26,28] #Healing Factor
	stats_levels[4] = [100,95,90,85,80,75,70,65,60,55] #Drain Factor
	stats_levels[5] = [10,12,14,16,18,20,22,24,26,28] #Recharge Speed

func button_text_manger(button : Button):
	var index = button.get_index()
	if index == 0:
		button.text = "Lv." + str(get_button_level(index)) + " $" + str(get_button_cost(index)) + "\nCash Multi\n" +\
		"x" + str(get_current_stats_value(index)) + " >> x" + str(get_next_stats_value(index))
	elif index == 1:
		button.text = "Lv." + str(get_button_level(index)) + " $" + str(get_button_cost(index)) + "\nAcceleration\n" +\
		str(get_current_stats_value(index)) + " >> " + str(get_next_stats_value(index))
	elif index == 2:
		button.text = "Lv." + str(get_button_level(index)) + " $" + str(get_button_cost(index)) + "\nSpeed\n" +\
		str(get_current_stats_value(index)) + " >> " + str(get_next_stats_value(index))
	elif index == 3:
		button.text = "Lv." + str(get_button_level(index)) + " $" + str(get_button_cost(index)) + "\nHealing Factor\n" +\
		str(get_current_stats_value(index)) + " >> " + str(get_next_stats_value(index))
	elif index == 4:
		button.text = "Lv." + str(get_button_level(index)) + " $" + str(get_button_cost(index)) + "\nDrain Factor\n" +\
		str(get_current_stats_value(index)) + "% >> " + str(get_next_stats_value(index)) + "%"
	elif index == 5:
		button.text = "Lv." + str(get_button_level(index)) + " $" + str(get_button_cost(index)) + "\nRecharge Speed\n" +\
		str(get_current_stats_value(index)) + " >> " + str(get_next_stats_value(index))
	else:
		button.text = "Not Available"

func get_next_stats_value(index : int) -> int:
	return stats_levels[index][get_button_level(index)+1]

func get_current_stats_value(index : int) -> int:
	return stats_levels[index][get_button_level(index)]

func get_button_cost(index : int) -> int:
	return button_costs[index][get_button_level(index)]

func get_button_level(index : int) -> int:
	return button_levels[index]

func button_manager(button : Button):
	AudioManager.button_sfx()
	var index = button.get_index()
	if index == 0:
		if GameManager.cash >= get_button_cost(index):
			player_stats.cash_multiplier = get_next_stats_value(index)
			_cash_manager(index,button)
	if index == 1:
		if GameManager.cash >= get_button_cost(index):
			player_stats.accer_factor = get_next_stats_value(index)
			_cash_manager(index,button)
	if index == 2:
		if GameManager.cash >= get_button_cost(index):
			player_stats.speed = get_next_stats_value(index)
			_cash_manager(index,button)
	if index == 3:
		if GameManager.cash >= get_button_cost(index):
			player_stats.healing_factor = get_next_stats_value(index)
			_cash_manager(index,button)
	if index == 4:
		if GameManager.cash >= get_button_cost(index):
			player_stats.drain_factor = get_next_stats_value(index)
			_cash_manager(index,button)
	if index == 5:
		if GameManager.cash >= get_button_cost(index):
			player_stats.recharge_speed = get_next_stats_value(index)
			_cash_manager(index,button)
	if index == 6:
		pass

func _cash_manager(index : int, button : Button):
	GameManager.cash -= get_button_cost(index)
	GameManager.cash_label.text = "$" + str(GameManager.cash)
	button_levels[index] += 1
	button_text_manger(button)
	GameManager.player_stats_label_manager()
	GameManager._save_data()
