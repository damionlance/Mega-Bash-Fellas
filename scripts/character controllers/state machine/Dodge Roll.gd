extends GroundedMovement


#private variables
var state_name = "Dodge Roll"

@export var animation_finished := false

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	# Process inputs
	if animation_finished:
		state.update_state("Idle")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	# Handle all relevant timers
	body.apply_friction(traction)
	# Process physics
	body.slide_off_ledge = false
	pass

func reset(delta):
	animation_finished = false
	
	body.attacking = false
	body.consecutive_jumps = 0
	body.velocity.x = dodge_roll * Input.get_axis(state.player_number + "Left", state.player_number + "Right") * delta
	pass
