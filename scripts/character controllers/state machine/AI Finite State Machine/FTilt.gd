extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()

#private variables
var state_name = "FTilt"

var wait_frames = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if wait_frames >= 5:
		if body.attacking == false: 
			state.update_state("Idle")
			return
	#state.reset_inputs()
	wait_frames += 1

func reset(_delta):
	wait_frames = 0
	state.release_attacks()
	var direction = sign(state.target_body.global_position.x - body.global_position.x)
	if direction == -1:
		var last_action = state.player_number + "Crush Left"
		Input.action_press(last_action, 1.0)
	if direction == 1:
		var last_action = state.player_number + "Crush Right"
		Input.action_press(last_action, 1.0)
