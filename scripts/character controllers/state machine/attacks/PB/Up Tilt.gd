extends GroundedMovement


#private variables
var state_name = "UTilt"

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
	
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	# Process inputs
	if animation_finished:
		state.update_state("Idle")
		return
	
	# Handle all relevant timers
	body.delta_v = delta_v
	body.apply_friction(traction)
	# Process physics
	pass

func reset(_delta):
	body.attacking = true
	cancellable = false
	animation_finished = false
	pass
