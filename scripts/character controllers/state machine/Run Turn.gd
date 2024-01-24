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
	if controller.attempting_shield:
		state.update_state("Shield")
		return
	if controller.attempting_attack:
		decide_attack()
		return
	if controller.attempting_jump:
		state.update_state("Jump Squat")
		return
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if controller.movement_direction.y < 0 and controller.movement_direction.y > -0.4:
		state.update_state("Crouch")
		return
	if body.velocity.x == 0:
		if controller.movement_direction.x == 0:
			state.update_state("Idle")
			return
		body.facing_direction = sign(controller.movement_direction.x)
		state.update_state("Running")
		return
	
	
	if controller.movement_direction.y < -0.4 and passthru_platform_checker.on_passthru_platform and can_drop_thru_platform:
		passthru_platform_checker.drop_thru_platform()
		state.update_state("Drop Through Platform")
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
