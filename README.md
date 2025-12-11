  Name: Donald Zhang
  Date: 12/9/2025
  Contact: dzhang22@pratt.edu
  License: Open Source, Creative Commons

About: Eat Eat Eat is a fish-eating game where the player starts as a small fish. During each run, the player can grow by finding and eating smaller fish. They can also occasionally find rare, sinking loot to earn extra cash or to satiate their draining hunger bar. When the player gets eaten by a larger fish, they die and return to the home screen. Back on the home screen, the player can purchase upgrades from the shop using the cash they earn from their runs. Once the player is ready, they can start their next run and continue through the main gameplay loop.

GitHub Link: 

Main Topics



Godot:
Node-Based Architecture: Nodes can be anything from being a CharacterBody2D, Sprite2D, CollisionShape2D, Camera2D, Label, TextureBar, Area2D or etc. Nodes can have parent and child nodes. It allows for a modular design pattern, since each node can be saved and plugged into another parent node. Every node can reference other nodes via @export, @onready, and other various methods.

Ready Function: Runs once immediately after starting the program
Process Function: Runs indefinitely at an inconsistent delta interval
Physics Process Function: Runs indefinitely at a near-consistent delta interval

The way collisions work is by…
StaticBody2D/CharacterBody2D/RigidBody2D >> Area2D >> CollisionShape2D >> Collision Layer/Mask >> Signals >> Connected Functions >> Run Specific Lines of Code

Player Movement:
func movement_manager(): This func manages the default movement for the player. 

Input.get_axis(“Input A”, “Input B”) is a preset func from Godot, and it checks if there is active input from either “Input A” or “Input B”. If “Input A” is true, it outputs -1, and if “Input B” is true, it outputs 1.
If there is no input, it outputs 0.
If x direction is not 0, it runs the first move_toward(), which allows the player to slowly ramp up speed; else, it runs the second move_toward(), which the player slows in speed.

Movement velocity is calculated using the move_toward() function, which allows the player to gradually approach velocity A to velocity B at the rate of C.

The move_toward() function is a preset function that takes in three parameters:
func move_foward(intital velocity : float, final velocity : float, rate : float):
Script: First float, Second float, Third float*
Moving: move_foward(current velocity, direction * player size * player speed, acceleration factor)
Not Moving: move_foward(current velocity, 0 , friction factor * player size)



Player Dash Mechanic:
if Input.is_action_just_pressed("dash") and dash_energy >= 100:
initialize_dash()

func initialize_dash(): This func sets your dash_energy back to 0, and temporarily set is_dashing to true for set time.
Within the physics_process func, it checks if is_dashing is true or not.  If dash_energy is below 100, it also runs the recharging func.

func dash(): This determines the dash velocity, and it checks if there is an active input for movement. If there is no active input for movement, the variable “dir” will be null and return Vector2(0.0,0.0). It will then default to the player's facing direction, or else the dash input will be wasted.

func recharging(delta): This func manages the recharging of the energy gauge at the rate of delta, and hard limits the dash_energy to the value 100.

func recharge(amount : int): This func recharges the energy gauge at a set amount, and hard-limits the dash_energy to the value of 100.



Interaction:
func _on_collectable_entered(body: RigidBody2D): This func runs if the connecting signal has indicated that a “body” has entered its collision shape. This func checks if the body is a RigidBody2D Node type. It then checks the RigidBody2D for a custom type if it is either a “Cash”, “Food”, or “Energy”. If either of those is true, it runs its respective code.
func _on_area_entered(area: EnemyInteraction):  This func runs if the connecting signal has indicated that an “area” has entered its collision shape. It checks if the area is the custom class “EnemyInteraction”. If true, it then compares the player’s size with the interacting fish’s size. If the player is bigger, the player is able to eat the other fish; otherwise, the player will get eaten and lose the current run.



Shop System:
The Node Architecture: Shop Node is a GridContainer that contains several button child nodes. It sits within the CanvasLayer Node, which keeps all the children at the highest level of visibility. Child nodes within CanvasLayer also move along with the camera. The CanvasLayer Node sits inside the GameManager Node, a custom Singleton node. A singleton node is a node that runs before anything else when you start the program, and it is a global node that can be referenced anywhere.

Set up Functions:
func set_button_cost(): Set the cost for every level for every button
func initial_button_levels(): Set the level for every button to 0
func set_stats_levels(): Set the value for every level for every stat

Supporting functions improve code readability, versatility, and modularity

func button_text_manger(button : Button): Manages every text initialization and changes for the shop buttons. Button.get_index() returns the button position order within the Shop(parent) node tree.
func button_manager(button : Button): Manages the event of changes respective for each button. Each event comprises changing the player's stats to the new stats and running the _cash_manager()

func  _cash_manager(index : int, button : Button): manages the deduction of the player's cash, increasing levels, managing related text labels, and saving data.

