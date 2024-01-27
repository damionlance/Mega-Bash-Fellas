extends GroundedMovement

#private variables
var state_name = "Dash"
var blend_parameter = "parameters/GroundedMovement/Running/blend_position"
var previous_strength := 0.0

var can_dash := false

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
			state.update_state("Dodge Roll")
		if controller.attempting_attack or controller.attempting_tilt:
			if decide_attack() : return
	if current_frame >= frames_to_sprint and controller.movement_direction.x == 0:
		body.apply_friction(traction)
	if abs(controller.movement_direction.x) <= 0.4:
		can_dash = true
	
	if controller.attempting_shield:
		body.velocity.x = 0
		state.update_state("Shield")
		return
	if controller.attempting_jump:
		state.update_state("Jump")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if abs(body.velocity.x) >= (sprint_speed * delta) and sign(controller.movement_direction.x) == sign(body.velocity.x) and current_frame >= frames_to_sprint:
		state.update_state("Run")
		return
	if body.velocity.x == 0:
		state.update_state("Idle")
		return
	if abs(controller.movement_direction.x) > 0.2 and sign(controller.movement_direction.x) != body.facing_direction and can_dash:
		body.facing_direction = -body.facing_direction
	
	if controller.attempting_attack or controller.attempting_tilt:
		if decide_attack() : return
	delta_v.x = sign(controller.movement_direction.x) * (base_dash_acceleration + abs(additional_dash_acceleration * controller.movement_direction.x)) * delta
	if abs(controller.movement_direction.x) > 0.2 and sign(controller.movement_direction.x) != sign(body.velocity.x):
		body.apply_friction(traction * 2)
	delta_v = grounded_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	previous_strength = controller.movement_direction.x
	pass

func reset(delta):
	can_dash = false
	body.slide_off_ledge = true
	current_speed = dash_speed
	current_frame = 0
	body.velocity.x = dash_speed * body.facing_direction * delta
	pass
