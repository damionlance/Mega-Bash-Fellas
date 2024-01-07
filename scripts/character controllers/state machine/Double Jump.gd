extends AerialMovement

class_name DoubleJump

#private variables
var state_name = "Double Jump"

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

var ready_to_jump := false

func update(delta):
	var delta_v = Vector2.ZERO
	# Handle all states
	if body.is_on_floor():
		state.update_state("Idle")
		return
	if body.velocity.y < 0:
		state.update_state("Fall")
		return
	if controller.attempting_jump and ready_to_jump and body.can_jump:
		state.update_state("Double Jump")
		return
	if controller.attempting_shield:
		state.update_state("Airdodge")
		return
	
	delta_v.x = sign(controller.movement_direction.x) * (base_air_acceleration + abs(additional_air_acceleration * controller.movement_direction.x)) * delta
	
	delta_v.y -= gravity * delta
	
	if body.velocity.y - delta_v.y < -falling_speed:
		delta_v.y = 0
	
	# Handle all relevant timers
	delta_v = regular_aerial_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	# Process physics
	ready_to_jump = not controller.attempting_jump
	pass

func reset(delta):
	body.consecutive_jumps += 1
	ready_to_jump = not controller.attempting_jump
	
	body.velocity.y = double_jump_force * delta
	body.velocity.x *= -1 if sign(controller.movement_direction.x) != sign(body.velocity.x) and abs(controller.movement_direction.x) > .3 else 1
	pass
