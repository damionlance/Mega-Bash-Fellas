extends GroundedMovement



#private variables
var state_name = "Run"
var blend_parameter = "parameters/GroundedMovement/Running/blend_position"
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	pass 

func update(delta):
	var delta_v = Vector2.ZERO
		# Handle all states
	if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Special") or Input.get_vector("Crush Left","Crush Right","Crush Down","Crush Up") != Vector2.ZERO:
		if decide_attack(): return
	if Input.is_action_just_pressed("Shield"):
		state.update_state("Shield")
		return
	if Input.is_action_just_pressed("Jump"):
		state.update_state("Jump Squat")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if body.velocity.x == 0.0:
		state.update_state("Idle")
		return
	if Input.get_action_strength("Down") > .7:
		state.update_state("Crouch")
		return
	
	
	if sign(Input.get_axis("Left", "Right")) != sign(body.velocity.x) or sign(Input.get_axis("Left", "Right")) != body.facing_direction:
		body.apply_friction(traction * 0.5)
	else:
		delta_v.x = sign(Input.get_axis("Left", "Right")) * (base_dash_acceleration + abs(additional_dash_acceleration * Input.get_axis("Left", "Right"))) * delta
	
	
	delta_v = grounded_movement_processing(delta, delta_v)
	body.delta_v = delta_v

func reset(_delta):
	current_speed = sprint_speed
	body.consecutive_jumps = 0
	pass
