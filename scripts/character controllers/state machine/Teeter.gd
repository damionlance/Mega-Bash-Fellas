extends GroundedMovement


#private variables
var state_name = "Teeter"

var can_drop_thru_platform := false
var can_dash := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	if controller.movement_direction.y > -.4:
		can_drop_thru_platform = true
	if controller.movement_direction.length() == 0:
		can_dash = true
	
	var delta_v = Vector2.ZERO
	# Handle all states
	if Input.is_action_just_pressed("Shield"):
		state.update_state("Shield")
		return
	if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Special") or Input.get_vector("Crush Left","Crush Right","Crush Down","Crush Up") != Vector2.ZERO:
		if decide_attack(): return
	if Input.is_action_just_pressed("Jump"):
		state.update_state("Jump Squat")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if Input.get_action_strength("Down") > .7:
		state.update_state("Crouch")
		return
	
	
	if abs(Input.get_axis("Left", "Right")) > .2:
		if abs(Input.get_axis("Left", "Right")) > 0.4 and can_dash:
			state.update_state("Dash")
			return
		elif abs(Input.get_axis("Left", "Right")) != body.facing_direction:
			state.update_state("Walk")
		return
	# Process inputs
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	can_tilt = true
	can_crush = true
	can_dash = false
	body.attacking = false
	can_drop_thru_platform = false
	body.consecutive_jumps = 0
	pass
