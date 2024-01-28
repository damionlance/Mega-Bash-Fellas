extends GroundedMovement


#private variables
var state_name = "Run Turn"

var can_drop_thru_platform := false
var can_dash := true
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
	if body.velocity.x == 0:
		state.update_state("Idle")
		return
	if Input.is_action_just_pressed(state.player_number + "Shield"):
		state.update_state("Shield")
		return
	if Input.is_action_just_pressed(state.player_number + "Attack") or Input.is_action_just_pressed(state.player_number + "Special") or Input.get_vector(state.player_number + "Crush Left",state.player_number + "Crush Right",state.player_number + "Crush Down",state.player_number + "Crush Up") != Vector2.ZERO:
		if decide_attack(): return
	if Input.is_action_just_pressed(state.player_number + "Jump"):
		state.update_state("Jump Squat")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if Input.get_action_strength(state.player_number + "Down") > .7:
		state.update_state("Crouch")
		return
	
	
	
	
	# Process inputs
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	body.facing_direction = sign(controller.movement_direction.x)
	can_tilt = true
	can_crush = true
	can_dash = false
	body.attacking = false
	can_drop_thru_platform = false
	body.consecutive_jumps = 0
	pass
