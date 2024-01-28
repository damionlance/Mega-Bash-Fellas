extends AerialMovement


#private variables
var state_name = "Side Special Interrupt"

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
	
	if cancellable:
		if Input.is_action_just_pressed(state.player_number + "Jump"):
			body.special = false
			state.update_state("Jump Squat")
			return
	
	if animation_finished:
		body.special = false
		state.update_state("Fall")
		return
	
	# Handle all relevant timers
	
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

func interrupt():
	body.delta_v.x = 0
	state.update_state("Side Special Interrupt")
