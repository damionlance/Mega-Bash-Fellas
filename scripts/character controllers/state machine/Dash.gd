extends GroundedMovement

#private variables
var state_name = "Dash"
var blend_parameter = "parameters/GroundedMovement/Running/blend_position"
var previous_strength := 0.0

var current_frame := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	pass 

func update(delta):
	current_frame += 1
	var delta_v = Vector2.ZERO
		# Handle all states
	if controller.attempting_jump:
		state.update_state("Jump")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if controller.movement_direction.length() < 0.29:
		state.update_state("Idle")
		return
	if current_frame == frames_to_sprint:
		state.update_state("Run")
		return
	
	delta_v.x = sign(controller.movement_direction.x) * (base_dash_acceleration + abs(additional_dash_acceleration * controller.movement_direction.x)) * delta
	
	delta_v = grounded_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	previous_strength = controller.movement_direction.x
	pass

func reset(delta):
	current_speed = dash_speed
	current_frame = 0
	body.facing_direction = sign(controller.movement_direction.x)
	body.velocity.x = dash_speed * body.facing_direction * delta
	pass
