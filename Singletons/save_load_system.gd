extends Node

const save_location = "user://EatEatEat_SaveFile.tres"

var SaveFileData : SaveData = SaveData.new()

func _ready() -> void:
	_load()
	if SaveFileData:
		print(SaveFileData.button_levels)
		print(SaveFileData.player_cash)
		print(SaveFileData.player_high_score)
		print(SaveFileData.player_stats_data)

func _save():
	ResourceSaver.save(SaveFileData,save_location)

func _load():
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)
