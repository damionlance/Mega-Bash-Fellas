extends Node

class_name AI_RandomDashDance

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
@onready var dash_dance = body.find_child("Dash")
@onready var grounded_movement = body.find_child("Grounded Movement")
@onready var aerial_movement = body.find_child("Aerial Movement")

@onready var player_number = get_parent().player_number
#private variables
var state_name = "Random Dash Dance"

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
	var axis = Input.get_axis(player_number + "Left", player_number + "Right")
	from = body.global_position + Vector3(axis, 0, 0)
	to = body.global_position + Vector3(axis, -1, 0)
	collision_mask = 3
	if state.probe_for_object(from, to, collision_mask).size() == 0:
		random_time = dash_dance.current_frame
	match waiting_for_dash:
		0:
			if dash_dance.current_frame >= random_time:
				waiting_for_dash = 1
				Input.action_release(last_action)
		1:
			match body.facing_direction:
				-1:
					last_action = player_number + "Right"
					Input.action_press(last_action)
				1:
					last_action = player_number + "Left"
					Input.action_press(last_action)
			random_time = randi() % 5
			waiting_for_dash = 0

func reset(_delta):
	player_number = get_parent().player_number
	waiting_for_dash = 0
	pass
