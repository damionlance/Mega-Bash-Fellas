extends Node

@onready var state = get_parent()
@onready var body = get_parent().get_parent().get_parent()
@onready var controller = get_parent().get_parent()
@onready var player_number = get_parent().player_number
#private variables
var state_name = "Recover"


# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if abs(body.position.x) < 10:
		state.update_state("Idle")
		return
	if body.state.current_state.state_name == "Idle": 
		state.update_state("Idle")
		return
	if body.state.current_state.state_name == "Jump":
		Input.action_release(get_parent().player_number + "Jump")
	elif body.state.current_state.state_name == "Fall" and not Input.is_action_pressed(get_parent().player_number + "Jump"):
		Input.action_press(get_parent().player_number + "Special")
		Input.action_press(get_parent().player_number + "Up")
	elif body.state.current_state.state_name == "Up Special":
		var target_position = (Vector3(0, 10, 0) - body.global_position).normalized()
		if target_position.x < 0:
			Input.action_press(get_parent().player_number + "Left",abs(target_position.x))
		else:
			Input.action_press(get_parent().player_number + "Right", abs(target_position.x))
			pass
		Input.action_press(get_parent().player_number + "Up", abs(target_position.y))
	elif body.state.current_state.state_name != "Up Special":
		var direction = -sign(body.global_position.x)
		var controller_strength = 1.0
		if direction == -1:
			state.release_movement()
			var last_action = player_number + "Left"
			Input.action_press(last_action, controller_strength)
		if direction == 1:
			state.release_movement()
			var last_action = player_number + "Right"
			Input.action_press(last_action,  controller_strength)

func reset(_delta):
	state.reset_inputs()
	Input.action_press(player_number + "Jump")
