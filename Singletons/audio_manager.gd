extends Node

func _ready() -> void:
	$"Default BGM".play()

func eating_sound():
	if randi() % 2 == 0:
		$"Eating Sound".play()
	else:
		$"Eating Sound2".play()

func button_sfx():
	$"Button UI SFX".play()

func coin_sfx():
	$"Coin SFX".play()
