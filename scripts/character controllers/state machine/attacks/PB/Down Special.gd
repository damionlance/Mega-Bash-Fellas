extends AerialMovement


#private variables
var state_name = "Down Special"

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
	
	if animation_finished:
		state.update_state("Idle")
		return
	delta_v.y = constants.gravity
	# Handle all relevant timers
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	# Handle all relevant tim
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
	body.velocity = Vector3.ZERO
	body.delta_v = Vector3.ZERO
	
