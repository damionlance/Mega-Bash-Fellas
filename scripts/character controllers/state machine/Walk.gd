extends GroundedMovement

#private variables
var state_name = "Walk"
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
	if Input.is_action_just_pressed("Shield"):
		state.update_state("Shield")
		return
	if body.velocity.x == 0:
		state.update_state("Idle")
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
	if abs(Input.get_axis("Left", "Right")) > 0.20 and sign(Input.get_axis("Left", "Right")) != body.facing_direction:
		state.update_state("Turn")
		return
	
	
	
	var target_speed = walk_speed * Input.get_axis("Left", "Right") * delta
	if abs(target_speed) < abs(body.velocity.x):
		body.apply_friction(traction * 2)
	else:
		delta_v.x = sign(Input.get_axis("Left", "Right"))
	
	body.delta_v = delta_v
	
	pass

func reset(_delta):
	can_tilt = true
	var turn = sign(Input.get_axis("Left", "Right")) 
	body.facing_direction = turn if turn != 0 else body.facing_direction
	
	pass
