extends AerialMovement


#private variables
var state_name = "Side Special"

var can_drop_thru_platform := false
var can_drift := false
var delta_time := 0.0166
var can_land := false
@export var active := false

@export var cancellable := false
@export var animation_finished := false

var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	if animation_finished or (Input.is_action_just_pressed(state.player_number + "Special") and cancellable):
		body.velocity = Vector3.ZERO
		body.special = false
		state.update_state("Fall")
		return
	
	# Handle all relevant timers
	
	# Process physics
	pass

func reset(_delta):
	active = false
	can_land = false
	delta_time = _delta
	can_drift = false
	body.velocity = Vector3.ZERO
	body.special = true
	cancellable = false
	animation_finished = false
	pass

func stop_jump():
	body.velocity.x = 0

func start_jump():
	if Input.get_axis(state.player_number + "Left", state.player_number + "Right") != 0:
		body.facing_direction = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right"))
	body.velocity.x = constants.side_special_velocity * body.facing_direction * delta_time
	body.velocity.y = 0
