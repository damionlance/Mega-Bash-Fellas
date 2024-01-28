extends GroundedMovement


#private variables
var state_name = "Grab Hold"
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
	if Input.get_vector(state.player_number + "Left", state.player_number + "Right", state.player_number + "Down", state.player_number + "Up").length() > .7:
		if Input.get_action_strength(state.player_number + "Down") > .7:
			state.update_state("Down Throw")
			return
		if Input.get_action_strength(state.player_number + "Up") > .7:
			state.update_state("Up Throw")
			return
		if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) > .7:
			if sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) == body.facing_direction:
				state.update_state("Cargo Carry")
				return
			else:
				state.update_state("Back Throw")
				return
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	grab = false
	body.attacking = true
	cancellable = false
	animation_finished = false
	pass
