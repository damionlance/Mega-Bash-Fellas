extends AerialMovement

#private variables
var state_name = "Jump Squat"

var jump_timer := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	state.update_state(state_name)
	
	pass # Replace with function body.

func update(delta):
	jump_timer += 1
	# Handle all states
	if jump_timer == jump_squat:
		state.update_state("Jump")
		return
	# Process inputs
	# Process physics
	pass

func reset(_delta):
	can_crush = true
	jump_timer = 0
	pass
