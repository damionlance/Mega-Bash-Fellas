extends GroundedMovement

class_name LandingLag

#private variables
var state_name = "Landing Lag"

var current_frame := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	current_frame += 1
	if current_frame == landing_lag:
		if controller.movement_direction.x != 0:
			state.update_state("Run")
			return
		state.update_state("Idle")
		return
	# Handle all states
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	# Process inputs
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	current_frame = 0
	body.consecutive_jumps = 0
	pass
