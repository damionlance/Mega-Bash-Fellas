extends AerialMovement

#private variables
var state_name = "Jump"

var ready_to_jump := false

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	# Handle all states
	if controller.attempting_attack:
		if decide_attack(): return
	if body.is_on_floor():
		state.update_state("Idle")
		return
	if body.velocity.y < 0:
		state.update_state("Fall")
		return
	if controller.jump_state == controller.jump_pressed and ready_to_jump and body.can_jump:
		state.update_state("Double Jump")
		return
	if controller.attempting_shield:
		state.update_state("Airdodge")
		return
	# Process inputs
	
	delta_v.x = sign(controller.movement_direction.x) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * controller.movement_direction.x)) * delta
	
	delta_v.y -= constants.gravity * delta
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	delta_v = regular_aerial_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	# Process physics
	ready_to_jump = not controller.attempting_jump
	pass

func reset(delta):
	can_tilt = true
	
	ready_to_jump = not controller.attempting_jump
	if controller.jump_state == 0:
		body.velocity.y = constants.short_force * delta
	else:
		body.velocity.y = constants.jump_force * delta
	
	body.velocity.x *= -1 if sign(controller.movement_direction.x) != sign(body.velocity.x) and abs(controller.movement_direction.x) > .3 else 1
	pass
