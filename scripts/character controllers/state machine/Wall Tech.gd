extends AerialMovement


#private variables
var state_name = "Wall Tech"

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
	# Handle all relevant timers
	# Process physics
	pass

func reset(delta):
	animation_finished = false
	body.velocity = Vector3.ZERO
	body.slide_off_ledge = false
	body.attacking = false
	body.consecutive_jumps = 0
	pass
