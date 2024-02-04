extends AerialMovement


#private variables
var state_name = "Up Special"

var can_drop_thru_platform := false
var can_drift := false
var delta_time := 0.0166
var can_land := false

@export var cancellable := false
@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	
	if body.is_on_floor() == false:
		can_land = true
	
	if can_land and body.is_on_floor():
		state.update_state("Landing Lag")
		return
	if animation_finished:
		state.update_state("Inactive Fall")
		return
	
	# Handle all relevant timers
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	if can_drift:
		delta_v.y -= constants.gravity * delta
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

func start_jump():
	body.facing_direction = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right"))
	can_drift = true
	body.velocity.y = constants.up_special_velocity * delta_time
	body.velocity.x = constants.base_up_special_drift * sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * delta_time
	body.velocity.x += constants.additional_up_special_drift * Input.get_axis(state.player_number + "Left", state.player_number + "Right") * delta_time
