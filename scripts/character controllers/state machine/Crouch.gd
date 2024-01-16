extends GroundedMovement


#private variables
var state_name = "Crouch"

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
		body.velocity.x *= -1
	
	if abs(controller.movement_direction.x) > controller.neutral_zone:
		if abs(controller.movement_direction.x) > 0.8:
			state.update_state("Dash")
			return
		if abs(controller.movement_direction.x) > 0.5:
			state.update_state("Walk")
			return
	if controller.movement_direction.y >= 0:
		state.update_state("Idle")
		return
	# Process inputs
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction * 2)
	# Process physics
	pass

func reset(_delta):
	body.attacking = false
	body.consecutive_jumps = 0
	pass
