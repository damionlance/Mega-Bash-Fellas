extends AerialMovement

#private variables
var state_name = "Ledge Grab"

var ready_to_jump := false
var can_climb := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	if Input.get_vector(state.player_number + "Left", state.player_number + "Right", state.player_number + "Down", state.player_number + "Up") == Vector2.ZERO:
		can_climb = true
	# Handle all states
	if Input.is_action_just_pressed(state.player_number + "Attack") or Input.is_action_just_pressed(state.player_number + "Special") or Input.get_vector(state.player_number + "Crush Left",state.player_number + "Crush Right",state.player_number + "Crush Down",state.player_number + "Crush Up") != Vector2.ZERO:
			if decide_attack(): return
	if Input.is_action_just_pressed(state.player_number + "Jump") and ready_to_jump:
		state.update_state("Ledge Jump")
		return
	if Input.is_action_just_pressed(state.player_number + "Shield"):
		# Roll
		return
	if Input.get_action_strength(state.player_number + "Up") > .7 and can_climb:
		state.update_state("Climb Ledge")
		return
	if Input.get_action_strength(state.player_number + "Down") < -.7 and can_climb:
		state.update_state("Fall")
		return
	if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) > .8 and can_climb:
		if sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) == body.facing_direction:
			state.update_state("Climb Ledge")
			return
		else:
			state.update_state("Fall")
			return
	# Process inputs
	
	# Handle all relevant timers
	# Process physics
	ready_to_jump = not Input.is_action_pressed(state.player_number + "Jump")

func reset(_delta):
	can_climb = false
	body.velocity = Vector3.ZERO
	body.delta_v = Vector2.ZERO
	can_tilt = false
	ready_to_jump = not Input.is_action_pressed(state.player_number + "Jump")
