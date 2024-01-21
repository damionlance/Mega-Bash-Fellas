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
	if current_frame <= 3:
		if controller.attempting_shield:
			pass # INSERT DODGE HERE
		if controller.attempting_attack:
			pass # INSERT ATTACK LOGIC HERE
	if controller.attempting_jump:
		state.update_state("Jump")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if abs(body.velocity.x) >= (sprint_speed * delta) and sign(controller.movement_direction.x) == sign(body.velocity.x):
		state.update_state("Run")
		return
	if controller.movement_direction.length() < 0.29 or abs(body.velocity.x) >= (sprint_speed * delta):
		state.update_state("Idle")
		return
	delta_v.x = sign(controller.movement_direction.x) * (base_dash_acceleration + abs(additional_dash_acceleration * controller.movement_direction.x)) * delta
	if sign(delta_v.x) != sign(body.velocity.x):
		body.apply_friction(traction * 2)
	delta_v = grounded_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	previous_strength = controller.movement_direction.x
	pass

func reset(delta):
	body.facing_direction = sign(controller.movement_direction.x)
	current_speed = dash_speed
	current_frame = 0
	body.velocity.x = dash_speed * body.facing_direction * delta
	pass
