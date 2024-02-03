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
		state.update_state("Unactionable Fall")
		return
	
	# Handle all relevant timers
	# Handle all relevant timers
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
	pass

func start_jump():
	body.facing_direction = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right"))
	can_drift = true
	var vector = Input.get_vector(state.player_number + "Left", state.player_number + "Right", state.player_number + "Down", state.player_number + "Up",).normalized()
	if vector == Vector2.ZERO: vector = Vector2.UP
	var temp = Vector3(vector.x, vector.y, 0)
	body.velocity = constants.up_special_velocity * temp * delta_time
