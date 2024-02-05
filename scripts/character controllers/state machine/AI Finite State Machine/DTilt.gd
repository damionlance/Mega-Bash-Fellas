extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
#private variables
var state_name = "DTilt"

var wait_frames = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if wait_frames >= 5:
		if body.attacking == false: 
			state.update_state("Idle")
			return
	wait_frames += 1

func reset(_delta):
	wait_frames = 0
	state.release_attacks()
	var last_action = state.player_number + "Crush Down"
	Input.action_press(last_action)
