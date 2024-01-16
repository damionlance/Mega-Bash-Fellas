extends GroundedMovement

#private variables
var state_name = "Walk"
var blend_parameter = "parameters/GroundedMovement/Running/blend_position"
var previous_strength := 0.0
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
		# Handle all states
	if controller.attempting_jump:
		state.update_state("Jump")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if controller.movement_direction.x == 0:
		state.update_state("Idle")
		return
	if controller.movement_direction.x > 0.4 and frame_one:
		state.update_state("Dash")
		return
	if controller.movement_direction.y < -0.4 and passthru_platform_checker.on_passthru_platform:
		passthru_platform_checker.drop_thru_platform()
	if controller.movement_direction.y < 0:
		state.update_state("Crouch")
		return
	
	
	
	var target_speed = walk_speed * controller.movement_direction.x * delta
	if abs(target_speed) < abs(body.velocity.x):
		body.apply_friction(traction * 2)
	else:
		delta_v.x = sign(controller.movement_direction.x) * traction
	
	body.delta_v = delta_v
	
	previous_strength = controller.movement_direction.x
	frame_one = false
	pass

func reset(_delta):
	can_drop_through_platform = false
	current_speed = walk_speed
	frame_one = true
	body.facing_direction = sign(controller.movement_direction.x)
	
	pass
