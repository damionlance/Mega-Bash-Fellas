extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
#private variables
var state_name = "Full Hop"


# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if body.state.current_state.state_name == "Jump" or body.state.current_state.state_name == "Fall":
		Input.action_release(state.player_number + "Jump")
	if body.state.current_state.state_name == "Idle": 
		state.update_state("Idle")
		return

func reset(_delta):
	var last_action = state.player_number + "Jump"
	Input.action_press(last_action)
