extends Area2D
class_name InteractionComponent

@export var player : PlayerFish
@export var player_stats : PlayerStats

var zoom_counter : int = 0

func consume(enemy_size : float):
	AudioManager.eating_sound()
	var amount = enemy_size/player_stats.size * 0.1
	player_stats.size += amount
	camera_zoom_manager()
	GameManager.player_stats_label_manager()
	player.player_scale_transition(player_stats.size)

func camera_zoom_manager():
	if player_stats.size > 1.5 + zoom_counter:
		zoom_counter += 1
		player.camera_zoom_transition(-Vector2(0.3,0.3),1)

func _on_collectable_entered(body: RigidBody2D):
	if body.type == "Cash":
		AudioManager.coin_sfx()
		GameManager.add_cash(body.cash_amount)
	if body.type == "Food":
		GameManager.heal(body.heal_amount)
		consume(0.05)
	if body.type == "Energy":
		player.recharge(body.energy_amount)
	body.queue_free()

func _on_area_entered(area: EnemyInteraction):
	var enemy = area.parent
	if enemy.size <= player_stats.size:
		enemy.queue_free()
		GameManager.score_maanger(1)
		GameManager.heal(player_stats.healing_factor)
		GameManager.add_cash(1)
		consume(enemy.size)
	else:
		AudioManager.eating_sound()
		GameManager.death_manager()
