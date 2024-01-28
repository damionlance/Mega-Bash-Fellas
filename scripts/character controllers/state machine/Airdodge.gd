extends AerialMovement

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
	
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	body.delta_v = delta_v
	regular_aerial_movement_processing(delta, delta_v)
	# Process physics
	pass

func reset(delta):
	can_fall_thru_platform = false
	velocity_tween = get_tree().create_tween()
	var axis = Input.get_vector(state.player_number + "Left", state.player_number + "Right", state.player_number + "Down", state.player_number + "Up")
	body.velocity = Vector3(axis.x, axis.y, 0) * constants.air_dodge_strength * delta
	velocity_tween.tween_property(body, "velocity", Vector3.ZERO, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	pass
