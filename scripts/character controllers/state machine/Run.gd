extends GroundedMovement



#private variables
var state_name = "Run"
var blend_parameter = "parameters/GroundedMovement/Running/blend_position"
var previous_strength := 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	pass 

func update(delta):
	var delta_v = Vector2.ZERO
		# Handle all states
	if controller.attempting_jump:
		state.update_state("Jump Squat")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if body.velocity.x == 0.0:
		state.update_state("Idle")
		return
	
	delta_v.x = sign(controller.movement_direction.x) * (base_dash_acceleration + abs(additional_dash_acceleration * controller.movement_direction.x)) * delta
	
	if sign(controller.movement_direction.x) != sign(body.velocity.x):
		body.apply_friction(traction / 2)
	
	delta_v = grounded_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	previous_strength = controller.movement_direction.x

func reset(_delta):
	current_speed = sprint_speed
	body.facing_direction = sign(controller.movement_direction.x)
	body.consecutive_jumps = 0
	pass
