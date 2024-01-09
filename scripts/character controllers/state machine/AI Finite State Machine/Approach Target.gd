extends Node

class_name AI_ApproachTarget

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()

#private variables
var state_name = "Approach Target"

var target_position = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	state.target_body = get_tree().get_current_scene().find_child("Body2", false)
	

func update(delta):
	var target_vector = (state.target_body.global_position - target_position)
	var next_path_point_to_target = state.point_path[0] - target_position if state.point_path.size() > 0 else Vector3.ZERO
	
	if target_vector.length() > 2:
		target_position = state.target_body.global_position
		state.point_path = state.astar.find_path(body.global_position, target_position)
	
	if next_path_point_to_target.length() < target_vector.length():
		state.point_path.pop_front()
	
	if state.point_path.size() == 0:
		state.update_state("Random Dash Dance")
		return
	
	var difference_in_position = (state.point_path[0] - body.global_position)
	
	if difference_in_position.y > 2.9:
		controller.full_hop()
	
	if difference_in_position.length() > 0.3:
		controller.movement_direction.x = sign(difference_in_position.x)
	else:
		state.point_path.pop_front()

func reset(_delta):
	target_position = state.target_body.global_position
	state.point_path = state.astar.find_path(body.global_position, target_position)
	pass
