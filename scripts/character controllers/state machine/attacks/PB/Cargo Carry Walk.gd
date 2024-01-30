extends GroundedMovement

#private variables
var state_name = "Cargo Carry Walk"
var blend_parameter = "parameters/GroundedMovement/Running/blend_position"
var frame_one = false
var can_drop_through_platform := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	pass 

func update(delta):
	if controller.movement_direction.y == 0:
		can_drop_through_platform == true
	var delta_v = Vector2.ZERO
	if body.velocity.x == 0:
		state.update_state("Forward Throw")
	if Input.get_vector(state.player_number + "Crush Left",state.player_number + "Crush Right",state.player_number + "Crush Down",state.player_number + "Crush Up") != Vector2.ZERO:
		if Input.get_action_strength(state.player_number + "Crush Up") > 0.7:
			state.update_state("Cargo Carry Throw Up")
			return
		if Input.get_action_strength(state.player_number + "Crush Up") > 0.7:
			state.update_state("Cargo Carry Throw Up")
			return
		if abs(Input.get_axis(state.player_number + "Crush Left", state.player_number + "Crush Right")) > 0.7 :
			if sign(Input.get_axis(state.player_number + "Crush Left", state.player_number + "Crush Right")) == body.facing_direction:
				state.update_state("Cargo Carry Throw Forward")
			else:
				state.update_state("Cargo Carry Throw Backward")
			return
	if Input.is_action_just_pressed(state.player_number + "Jump"):
		state.update_state("Cargo Carry Jump Squat")
		return
	if not body.is_on_floor():
		state.update_state("Cargo Carry Fall")
		return
	
	state.grabbed_body.global_position = body.global_position
	state.grabbed_body.facing_direction = body.facing_direction
	if Input.get_axis(state.player_number + "Left", state.player_number + "Right") != 0:
		body.facing_direction = sign( Input.get_axis(state.player_number + "Left", state.player_number + "Right") )
	
	
	var target_speed = walk_speed * Input.get_axis(state.player_number + "Left", state.player_number + "Right") * delta
	if abs(target_speed) < abs(body.velocity.x):
		body.apply_friction(traction * 2)
	else:
		delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right"))
	
	body.delta_v = delta_v
	
	pass

func reset(_delta):
	var turn = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) 
	body.facing_direction = turn if turn != 0 else body.facing_direction
	
	pass