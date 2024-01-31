extends AerialMovement


#private variables
var state_name = "Neutral Special"

var can_drop_thru_platform := false
var can_drift := false
var delta_time := 0.0166
var can_land := false
var aerial := false

@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	
	if aerial and body.is_on_floor():
		state.update_state("Landing Lag")
		return
	if animation_finished:
		state.update_state("Idle")
		return
	# Handle all relevant timers
	# Handle all relevant timers
	delta_v.y -= constants.gravity * delta
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * (constants.base_up_special_drift + abs(constants.additional_up_special_drift * Input.get_axis(state.player_number + "Left", state.player_number + "Right"))) * delta
	
	body.delta_v = delta_v
	# Process physics
	pass

func reset(_delta):
	aerial = body.is_on_floor()
	can_land = false
	delta_time = _delta
	can_drift = false
	body.velocity = Vector3.ZERO
	body.special = true
	animation_finished = false
	pass
