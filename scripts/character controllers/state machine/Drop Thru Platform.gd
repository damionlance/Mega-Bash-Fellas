extends AerialMovement

#private variables
var state_name = "Drop Through Platform"

var ready_to_jump := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	# Handle all states
	if Input.is_action_just_pressed(state.player_number + "Attack") or Input.is_action_just_pressed(state.player_number + "Special") or Input.get_vector(state.player_number + "Crush Left",state.player_number + "Crush Right",state.player_number + "Crush Down",state.player_number + "Crush Up") != Vector2.ZERO:
			if decide_attack(): return
	if body.is_on_floor():
		state.update_state("Landing Lag")
		return
	if Input.is_action_just_pressed(state.player_number + "Jump") and ready_to_jump and body.can_jump:
		state.update_state("Double Jump")
		return
	if Input.is_action_just_pressed(state.player_number + "Shield"):
		state.update_state("Airdodge")
		return
	# Process inputs
	delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * Input.get_axis(state.player_number + "Left", state.player_number + "Right"))) * delta
	
	delta_v.y -= constants.gravity * delta
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	delta_v = regular_aerial_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	# Process physics
	ready_to_jump = not Input.is_action_pressed(state.player_number + "Jump")

func reset(_delta):
	can_tilt = true
	ready_to_jump = not Input.is_action_pressed(state.player_number + "Jump")
