extends AerialMovement


#private variables
var state_name = "Uair"

var can_drop_thru_platform := false
var can_dash := false

@export var cancellable := false
@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	
	if body.is_on_floor():
		state.update_state("Landing Lag")
	if animation_finished:
		state.update_state("Fall")
		return
	delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * Input.get_axis(state.player_number + "Left", state.player_number + "Right"))) * delta
	
	# Handle all relevant timers
	delta_v.y -= constants.gravity * delta
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	delta_v = regular_aerial_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	# Process physics
	pass

func reset(_delta):
	can_fall_thru_platform = false
	body.attacking = true
	cancellable = false
	animation_finished = false
	pass
