extends AerialMovement

#private variables
var state_name = "Cargo Carry Fall"

var ready_to_jump := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	# Handle all states
	if Input.get_vector(state.player_number + "Crush Left",state.player_number + "Crush Right",state.player_number + "Crush Down",state.player_number + "Crush Up") != Vector2.ZERO:
		if Input.get_action_strength(state.player_number + "Crush Up") > 0.7:
			state.update_state("Cargo Carry Throw Up")
			return
		if Input.get_action_strength(state.player_number + "Crush Up") > 0.7:
			state.update_state("Cargo Carry Throw Up")
			return
		if abs(Input.get_axis(state.player_number + "Crush Left", state.player_number + "Crush Right")) > 0.7 :
			if sign(Input.get_axis(state.player_number + "Crush Left", state.player_number + "Crush Right")) == body.facing_direction:
				state.update_state("Cargo Carry Throw Forward")
			else:
				state.update_state("Cargo Carry Throw Backward")
			return
	if body.is_on_floor():
		state.update_state("Forward Throw")
		return
	# Process inputs
	delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * Input.get_axis(state.player_number + "Left", state.player_number + "Right"))) * delta
	
	delta_v.y -= constants.gravity * delta
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	delta_v = regular_aerial_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	state.grabbed_body.global_position = body.global_position
	state.grabbed_body.facing_direction = body.facing_direction
	# Process physics

func reset(_delta):
	can_tilt = true
