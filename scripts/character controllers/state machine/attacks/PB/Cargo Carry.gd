extends GroundedMovement


#private variables
var state_name = "Forward Throw"
var can_drop_thru_platform := false
var can_dash := false
var grab := false

@export var cancellable := false
@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	
	# Process inputs
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
	if not body.is_on_floor():
		state.update_state("Cargo Carry Fall")
		return
	if body.is_on_floor() and Input.get_axis(state.player_number + "Left", state.player_number + "Right"):
		state.update_state("Cargo Carry Walk")
		return
	state.grabbed_body.global_position = body.global_position
	state.grabbed_body.facing_direction = body.facing_direction
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	grab = false
	body.attacking = true
	state.grabbed_body.state.update_state("Get Cargo Carried")
	cancellable = false
	animation_finished = false
	pass
