extends Node

class_name AI_JumpToPlatform

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
@onready var dash_dance = body.find_child("Dash")
@onready var grounded_movement = body.find_child("Grounded Movement")
#private variables
var state_name = "Jump Up To Platform"
var ready_to_update_state := false

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self

func update(delta):
	if body.is_on_floor() and ready_to_update_state:
		state.update_state("Idle")
		return
	if not body.is_on_floor():
		ready_to_update_state = true


func reset(_delta):
	ready_to_update_state = false
	controller.jump_input = true
