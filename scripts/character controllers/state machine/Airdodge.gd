extends AerialMovement

class_name Airdodge

#private variables
var state_name = "Airdodge"

var velocity_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	# Handle all states
	if body.is_on_floor():
		state.update_state("Landing Lag")
		velocity_tween.stop()
		return
	if body.velocity == Vector3.ZERO:
		state.update_state("Inactive Fall")
		return
	# Process inputs
	
	if body.velocity.y - delta_v.y < -falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	body.delta_v = delta_v
	regular_aerial_movement_processing(delta, delta_v)
	# Process physics
	pass

func reset(delta):
	velocity_tween = get_tree().create_tween()
	body.velocity = Vector3(controller.movement_direction.x, controller.movement_direction.y, 0) * jump_force * delta
	velocity_tween.tween_property(body, "velocity", Vector3.ZERO, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	body.facing_direction = sign(controller.movement_direction.x)
	pass
