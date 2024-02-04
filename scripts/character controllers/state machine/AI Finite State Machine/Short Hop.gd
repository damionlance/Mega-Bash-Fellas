extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
@onready var player_number = get_parent().player_number
#private variables
var state_name = "Short Hop"
var last_action

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if body.state.current_state.state_name == "Jump Squat":
		Input.action_release(state.player_number + "Jump")
	if body.state.current_state.state_name == "Idle": 
		state.update_state("Idle")
		return
	var direction = sign(state.target_body.global_position.x - body.global_position.x)
	var distance = abs(state.target_body.global_position.x - body.global_position.x)
	var controller_strength = clampf(.2 + distance / 5, .2, 1.0)
	if direction == -1:
		state.release_movement()
		var last_action = player_number + "Left"
		Input.action_press(last_action, controller_strength)
	if direction == 1:
		state.release_movement()
		Input.action_release(player_number + "Left")
		var last_action = player_number + "Right"
		Input.action_press(last_action,  controller_strength)

func reset(_delta):
	var last_action = state.player_number + "Jump"
	Input.action_press(last_action)
