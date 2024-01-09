extends Node

class_name AI_Idle

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()

#private variables
var state_name = "Idle"


# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	state.update_state("Idle")
	

func update(delta):
	
	if body.is_on_floor():
		state.update_state("Approach Target")
	pass

func reset(_delta):
	controller.jump_input = false
