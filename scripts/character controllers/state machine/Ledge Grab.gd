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
	if controller.movement_direction == Vector2.ZERO:
		can_climb = true
	# Handle all states
	if controller.attempting_attack:
		# LEdge attack
		if decide_attack(): return
	if controller.attempting_jump and ready_to_jump:
		state.update_state("Ledge Jump")
		return
	if controller.attempting_shield:
		# Roll
		return
	if controller.movement_direction.y > .8 and can_climb:
		state.update_state("Climb Ledge")
		return
	if controller.movement_direction.y < -.8 and can_climb:
		state.update_state("Fall")
		return
	if abs(controller.movement_direction.x) > .8 and can_climb:
		if sign(controller.movement_direction.x) == body.facing_direction:
			state.update_state("Climb Ledge")
			return
		else:
			state.update_state("Fall")
			return
	# Process inputs
	
	# Handle all relevant timers
	# Process physics
	ready_to_jump = not controller.attempting_jump

func reset(_delta):
	can_climb = false
	body.velocity = Vector3.ZERO
	body.delta_v = Vector2.ZERO
	can_tilt = false
	ready_to_jump = not controller.attempting_jump
