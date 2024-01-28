extends GroundedMovement


#private variables
var state_name = "Crouch"
@export var can_drop_thru_platform := false
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
	
	if Input.get_action_strength(state.player_number + "Down") > 0.7 and passthru_platform_checker.on_passthru_platform and can_drop_thru_platform:
		passthru_platform_checker.drop_thru_platform()
		state.update_state("Drop Through Platform")
		return
	
	if controller.movement_direction.x != 0 and sign(controller.movement_direction.x) != sign(body.facing_direction):
		body.velocity.x *= -1
	
	if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) > .2:
		if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) > 0.7:
			state.update_state("Dash")
			return
		if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) > 0.7:
			state.update_state("Walk")
			return
	if Input.get_action_strength(state.player_number + "Down") < 0.7:
		state.update_state("Idle")
		return
	# Process inputs
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction * 2)
	# Process physics
	pass

func reset(_delta):
	can_drop_thru_platform = false
	can_tilt = true
	body.attacking = false
	body.consecutive_jumps = 0
	pass
