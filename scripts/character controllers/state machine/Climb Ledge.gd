extends AerialMovement

#private variables
var state_name = "Climb Ledge"

@export var animation_finished := false
var original_position
@onready var ledge_tracking := $"../../../Ledge Tracking/Climb Tracker"
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	if animation_finished == true:
		state.update_state("Idle")
		ledge_tracking.position = Vector3.ZERO
		return
	# Process inputs
	body.global_position  = original_position + (ledge_tracking.position * Vector3(body.facing_direction, 1, 1))
	# Handle all relevant timers
	# Process physics

func reset(_delta):
	original_position = body.global_position
	animation_finished = false
