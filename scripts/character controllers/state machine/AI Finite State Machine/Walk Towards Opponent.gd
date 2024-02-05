extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
@onready var dash_dance = body.find_child("Dash")
@onready var grounded_movement = body.find_child("Grounded Movement")
@onready var aerial_movement = body.find_child("Aerial Movement")

@onready var player_number = get_parent().player_number
#private variables
var state_name = "Walk Towards Opponent"

var random_time := 0
var waiting_for_dash := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self

var last_action : String

func update(delta):
	var from
	var to
	var collision_mask
	
	#Check if there's ground where you're dashing
	if state.target_body.is_on_floor() and state.target_body.global_position.y != body.global_position.y:
		#Pathfind
		pass
	var distance = abs(state.target_body.global_position.x - body.global_position.x)
	if distance < 2 and abs(body.velocity.x) > 7 or state.target_body.global_position.y < body.global_position.x and state.target_body.global_position.y > 0:
		state.reset_inputs()
		Input.action_press(player_number + "Down")
	else:
		Input.action_release(player_number + "Down")
	var direction = sign(state.target_body.global_position.x - body.global_position.x)
	var controller_strength = clampf(.2 + distance / 5, .2, 1.0)
	if direction == -1:
		last_action = player_number + "Left"
		Input.action_press(last_action, controller_strength)
	if direction == 1:
		last_action = player_number + "Right"
		Input.action_press(last_action,  controller_strength)

func reset(_delta):
	player_number = get_parent().player_number
	waiting_for_dash = 0
	pass
