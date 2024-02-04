extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
@onready var dash_dance = body.find_child("Dash")
@onready var grounded_movement = body.find_child("Grounded Movement")
@onready var aerial_movement = body.find_child("Aerial Movement")

@onready var player_number = get_parent().player_number
#private variables
var state_name = "Instant UAir"

var random_time := 0
var waiting_for_dash := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self

var last_action : String

func update(delta):
	
	if not body.is_on_floor():
		if body.state.current_state.state_name.contains("Jump"):
			if body.state.current_state.state_name != "Uair":
				Input.action_press(player_number + "Crush Up")
		
	

func reset(_delta):
	controller.short_hop()
	pass
