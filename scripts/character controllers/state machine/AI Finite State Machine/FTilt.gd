extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()

#private variables
var state_name = "FTilt"


# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	
	if body.state.current_state.state_name == "Idle": 
		state.update_state("Idle")
		return
	state.reset_inputs()

func reset(_delta):
	state.reset_inputs()
	var direction = sign(state.target_body.global_position.x - body.global_position.x)
	if direction == -1:
		var last_action = state.player_number + "Crush Left"
		Input.action_press(last_action)
	if direction == 1:
		var last_action = state.player_number + "Crush Right"
		Input.action_press(last_action)
