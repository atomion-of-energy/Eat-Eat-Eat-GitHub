extends Resource
class_name PlayerStats

@export var size : float = 1
@export var cash_multiplier : float = 1.0

@export_category("Sustainability")
@export var drain_factor : int = 100
@export var healing_factor : int = 10

@export_category("Movement")
@export var speed : int = 200
@export var accer_factor : float = 5
@export var friction : float = 2

@export_category("Dash")
@export var initial_dash_energy : int = 10
@export var dash_factor : float = 10
@export var dash_velocity : int = 400
@export var recharge_speed : float = 10
