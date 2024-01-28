extends GroundedMovement


#private variables
var state_name = "Back Throw"

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
	
	# Process inputs
	if animation_finished:
		state.update_state("Idle")
		return
	
	# Handle all relevant timers
	body.delta_v = delta_v
	# Process physics
	pass

func reset(_delta):
	cancellable = false
	animation_finished = false
	pass
