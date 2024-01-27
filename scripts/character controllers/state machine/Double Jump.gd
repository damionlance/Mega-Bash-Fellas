extends AerialMovement

class_name DoubleJump

#private variables
var state_name = "Double Jump"

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

var ready_to_jump := false

func update(delta):
	var delta_v = Vector2.ZERO
	# Handle all states
	if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Special") or Input.get_vector("Crush Left","Crush Right","Crush Down","Crush Up") != Vector2.ZERO:
			if decide_attack(): return
	if body.is_on_floor():
		state.update_state("Landing Lag")
		return
	if body.velocity.y < 0:
		state.update_state("Fall")
		return
	if Input.is_action_just_pressed("Jump") and ready_to_jump and body.can_jump:
		state.update_state("Double Jump")
		return
	if Input.is_action_just_pressed("Shield"):
		state.update_state("Airdodge")
		return
	
	delta_v.x = sign(Input.get_axis("Left", "Right")) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * Input.get_axis("Left", "Right"))) * delta
	
	delta_v.y -= constants.gravity * delta
	
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	
	# Handle all relevant timers
	delta_v = regular_aerial_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	# Process physics
	ready_to_jump = not Input.is_action_pressed("Jump")
	pass

func reset(delta):
	can_tilt = true
	body.consecutive_jumps += 1
	ready_to_jump = not controller.attempting_jump
	
	body.velocity.y = constants.double_jump_force * delta
	body.velocity.x *= -1 if sign(Input.get_axis("Left", "Right")) != sign(body.velocity.x) and abs(Input.get_axis("Left", "Right")) > .3 else 1
	body.velocity.x = clamp(body.velocity.x, -constants.double_jump_speed_cap * delta, constants.double_jump_speed_cap * delta)
	pass
