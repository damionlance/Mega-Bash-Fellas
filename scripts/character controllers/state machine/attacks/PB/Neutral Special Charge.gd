extends AerialMovement


#private variables
var state_name = "Neutral Special"

var can_drop_thru_platform := false
var can_drift := false
var delta_time := 0.0166
var can_land := false

@export var cancellable := false
@export var animation_finished := false
@export var middle_charge := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	
	if animation_finished:
		state.update_state("Neutral Special Full")
		return
	if not Input.is_action_pressed(state.player_number + "Special"):
		if middle_charge == true:
			state.update_state("Neutral Special Middle")
			return
		else:
			state.update_state("Neutral Special Low")
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
	can_land = false
	delta_time = _delta
	can_drift = false
	body.velocity = Vector3.ZERO
	body.special = true
	cancellable = false
	animation_finished = false
	middle_charge = false
	pass
