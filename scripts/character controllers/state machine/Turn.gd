extends GroundedMovement


#private variables
var state_name = "Turn"

var can_drop_thru_platform := false
var can_dash := true
@export var animation_finished := false
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
	if animation_finished:
		state.update_state("Idle")
		body.facing_direction = -body.facing_direction
		return
	if Input.is_action_just_pressed("Shield"):
		body.facing_direction = sign(Input.get_axis("Left", "Right"))
		state.update_state("Shield")
		return
	if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Special") or Input.get_vector("Crush Left","Crush Right","Crush Down","Crush Up") != Vector2.ZERO:
		if decide_attack(): return
	if Input.is_action_just_pressed("Jump"):
		
		body.facing_direction = sign(Input.get_axis("Left", "Right"))
		state.update_state("Jump Squat")
		return
	if not body.is_on_floor():
		body.facing_direction = sign(Input.get_axis("Left", "Right"))
		state.update_state("Fall")
		return
	if Input.get_action_strength("Down") > .7:
		state.update_state("Crouch")
		return
	
	if abs(Input.get_axis("Left","Right")) > .7:
		state.update_state("Dash")
		return
	
	# Process inputs
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	animation_finished = false
	can_tilt = true
	can_crush = true
	can_dash = false
	body.attacking = false
	can_drop_thru_platform = false
	body.consecutive_jumps = 0
	pass
