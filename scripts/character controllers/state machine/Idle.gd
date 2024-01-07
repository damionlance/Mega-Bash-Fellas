extends GroundedMovement

class_name Idle

#private variables
var state_name = "Idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	# Handle all states
	
	if controller.attempting_jump:
		state.update_state("Jump Squat")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if controller.movement_direction.x != 0 and sign(controller.movement_direction.x) != sign(body.facing_direction):
		print("PIVOT!!")
		body.velocity.x *= -1
	if abs(controller.movement_direction.x) > controller.neutral_zone:
		if abs(controller.movement_direction.x) > 0.4:
			state.update_state("Dash")
			return
		state.update_state("Walk")
		return
	# Process inputs
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	body.consecutive_jumps = 0
	pass
