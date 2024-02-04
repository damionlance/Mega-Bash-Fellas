extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
#private variables
var state_name = "Jab"


# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	
	if body.state.current_state.state_name == "Idle": 
		state.update_state("Idle")
		return

func reset(_delta):
	state.reset_inputs()
	var last_action = state.player_number + "Attack"
	Input.action_press(last_action)
