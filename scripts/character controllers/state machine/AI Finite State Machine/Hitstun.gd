extends Node

class_name AI_Hitstun

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()

#private variables
var state_name = "Hitstun"
var hitstun_frames := 0
var wait_time := 100
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if hitstun_frames >= wait_time:
		state.update_state("Idle")
		wait_time = 100

func reset(_delta):
	pass
