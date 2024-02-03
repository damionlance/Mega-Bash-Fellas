extends GroundedMovement

#private variables
var state_name = "Dash"
var blend_parameter = "parameters/GroundedMovement/Running/blend_position"

var can_dash := false
@export var animation_finished := false

var current_frame := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	pass 

func update(delta):
	current_frame += 1
	var delta_v = Vector2.ZERO
	
	#Allow some actions to happen early in a dash, like a Bash or dodge
	print(current_frame)
	if current_frame <= 3:
		print("Testin")
		if Input.is_action_just_pressed(state.player_number + "Shield"):
			state.update_state("Dodge Roll")
		if Input.is_action_just_pressed(state.player_number + "Attack") or Input.is_action_just_pressed(state.player_number + "Special") or Input.get_vector(state.player_number + "Crush Left",state.player_number + "Crush Right",state.player_number + "Crush Down",state.player_number + "Crush Up") != Vector2.ZERO:
			if decide_attack(true): return
	
	if current_frame >= frames_to_sprint and Input.get_axis(state.player_number + "Left", state.player_number + "Right") == 0:
		body.apply_friction(traction)
	if Input.get_vector(state.player_number + "Left", state.player_number + "Right", state.player_number + "Down", state.player_number + "Up").length() <= 0.7:
		can_dash = true
	
	if Input.is_action_just_pressed(state.player_number + "Shield"):
		body.velocity.x = 0
		state.update_state("Shield")
		return
	if Input.is_action_just_pressed(state.player_number + "Jump"):
		state.update_state("Jump")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if abs(body.velocity.x) >= (dash_speed * delta) and sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) == body.facing_direction and animation_finished:
		state.update_state("Run")
		return
	if body.velocity.x == 0:
		state.update_state("Idle")
		return
	if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) > 0.2 and sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) != body.facing_direction and can_dash:
		state.update_state("Turn")
		return
	if Input.is_action_just_pressed(state.player_number + "Attack") or Input.is_action_just_pressed(state.player_number + "Special") or Input.get_vector(state.player_number + "Crush Left",state.player_number + "Crush Right",state.player_number + "Crush Down",state.player_number + "Crush Up") != Vector2.ZERO:
			print("Hey!")
			if decide_attack(false): return
	
	if abs(body.velocity.x) >= dash_speed * delta and animation_finished and sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) != body.facing_direction:
		state.update_state("Run Turn")
		return
	else:
		delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * (base_dash_acceleration + abs(additional_dash_acceleration *  Input.get_axis(state.player_number + "Left", state.player_number + "Right"))) * delta
	if abs(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) > 0.2 and sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) != sign(body.velocity.x):
		body.apply_friction(traction * 2)
	
	delta_v = grounded_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	pass

func reset(delta):
	animation_finished = false
	can_dash = false
	body.slide_off_ledge = true
	current_speed = dash_speed
	current_frame = 0
	body.facing_direction = body.facing_direction if Input.get_axis(state.player_number + "Left", state.player_number + "Right") == 0 else sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right"))
	body.velocity.x = dash_speed * body.facing_direction * delta
	pass
