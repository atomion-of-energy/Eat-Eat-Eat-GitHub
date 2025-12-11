extends CharacterBody2D
class_name PlayerFish

@export var player_stats : PlayerStats

var x_direction
var y_direction
var dir : Vector2
var facing_dir : float
var mouse_pos : Vector2
var size : float = 1
var is_dashing : bool = false
var dash_energy : float = 0
var movement : bool = true

@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var dash_bar: TextureProgressBar = $DashBar
@onready var interaction_component: InteractionComponent = $InteractionComponent

func _ready() -> void:
	position = GameManager.world_size/2
	camera_2d.zoom = Vector2(2,2)
	
	camera_2d.limit_right = GameManager.world_size.x
	camera_2d.limit_bottom = GameManager.world_size.y
	
	dash_energy = player_stats.initial_dash_energy
	dash_bar.max_value = 100
	dash_bar.value = dash_energy
	
	GameManager.toggle_game_state.connect(toggle_game_state)
	scale = Vector2(player_stats.size,player_stats.size)

func toggle_game_state(STATE : String):
	#this function allows for the toggle between two different game states
	if STATE == "PAUSE":
		#The "PAUSE" state is when the player is effectively dead and can interact with the shop
		GameManager.highscore_manager(GameManager.total_score)
		GameManager.largest_size_manager()
		GameManager.game_over_score_label()
		player_stats.size = 0.5
		scale = Vector2(0.5,0.5)
		movement = false
		velocity = Vector2.ZERO
		position = GameManager.world_size/2
		GameManager.player_stats_label_manager()
		dash_energy = player_stats.initial_dash_energy
		camera_2d.zoom = Vector2(2,2)
		interaction_component.zoom_counter = 0
	if STATE == "CONTINUE":
		#The "CONTINUE" state is when the player is effectively alive and is actively playing
		movement = true
		scale = Vector2(player_stats.size,player_stats.size)

func _physics_process(delta: float) -> void:
	if !movement:
		return
	mouse_pos = get_global_mouse_position()
	if !is_dashing:
		movement_manager()
	elif is_dashing:
		dash()
	if dash_energy < 100:
		recharging(delta)
	animation_manager(x_direction)
	move_and_slide()
	label.text = str(size)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash") and dash_energy >= 100:
		initialize_dash()

func camera_zoom_transition(new_zoom : Vector2, zoom_rate : float):
	if camera_2d.zoom + new_zoom < Vector2(0.3,0.3):
		return
	var tween = get_tree().create_tween()
	tween.tween_property(camera_2d,"zoom",camera_2d.zoom + new_zoom,zoom_rate)

func player_scale_transition(new_scale : float):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2(new_scale,new_scale),1)

func movement_manager():
	#This function manages the movement, by looking out for WASD inputs
	#Movements are purposely sluggish with the implementation of move_towards and "friction"
	x_direction = Input.get_axis("move_left", "move_right")
	if x_direction:
		velocity.x = move_toward(velocity.x,x_direction * player_stats.speed * player_stats.size,player_stats.accer_factor)
	else:
		velocity.x = move_toward(velocity.x,0,player_stats.friction * player_stats.size)
	
	y_direction = Input.get_axis("move_up", "move_down")
	if y_direction:
		velocity.y = move_toward(velocity.y,y_direction * player_stats.speed * player_stats.size,player_stats.accer_factor)
	else:
		velocity.y = move_toward(velocity.y,0,player_stats.friction * player_stats.size)
	
	dir = Vector2(x_direction,y_direction).normalized()

func animation_manager(dir):
	if dir < 0:
		sprite_2d.flip_h = false
	elif dir > 0:
		sprite_2d.flip_h = true

func initialize_dash():
	dash_energy = 0
	var size_factor : float = player_stats.size
	if size_factor < 1.0:
		size_factor = 1.0
	is_dashing = true
	await get_tree().create_timer(.2).timeout
	is_dashing = false

func dash():
	var size_factor : float = player_stats.size
	if size_factor < 1.0:
		size_factor = 1.0
	if dir:
		velocity = dir * player_stats.dash_velocity * size_factor
	elif !sprite_2d.flip_h:
		print(dir)
		velocity = Vector2(-0.7,0) * player_stats.dash_velocity * size_factor
	else:
		print(dir)
		velocity = Vector2(0.7,0) * player_stats.dash_velocity * size_factor

func recharging(delta):
	dash_energy += delta * player_stats.recharge_speed
	if dash_energy > 100:
		dash_energy = 100
	dash_bar.value = dash_energy

func recharge(amount : int):
	dash_energy += amount
	if dash_energy > 100:
		dash_energy = 100
	dash_bar.value = dash_energy
