extends Node

class_name AI_RandomDashDance

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
@onready var dash_dance = body.find_child("Dash")
@onready var grounded_movement = body.find_child("Grounded Movement")
@onready var aerial_movement = body.find_child("Aerial Movement")
#private variables
var state_name = "Random Dash Dance"

var random_time := 0
var waiting_for_dash := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self

func update(delta):
	var from
	var to
	var collision_mask
	#check if there's a platform to jump up to
	from = body.global_position + body.velocity * aerial_movement.time_of_jump+ Vector3(0, 0.1, 0)
	to = from + Vector3.UP * (aerial_movement.jump_force * delta) * (aerial_movement.time_of_jump / 2)
	collision_mask = 3
	if state.probe_for_object(from, to, collision_mask).size() != 0:
		state.update_state("Jump Up To Platform")
		return
	
	#Check if there's ground where you're dashing
	from = body.global_position + Vector3(controller.movement_direction.x, 0, 0)
	to = body.global_position + Vector3(controller.movement_direction.x, -1, 0)
	collision_mask = 3
	if state.probe_for_object(from, to, collision_mask).size() == 0:
		random_time = dash_dance.current_frame
	
	match waiting_for_dash:
		0:
			if dash_dance.current_frame >= random_time:
				waiting_for_dash = 1
				controller.movement_direction.x = 0
		1:
			controller.movement_direction.x = body.facing_direction * -1
			random_time = randi() % grounded_movement.frames_to_sprint
			waiting_for_dash = 0

func reset(_delta):
	waiting_for_dash = 0
	controller.jump_input = false
	pass
