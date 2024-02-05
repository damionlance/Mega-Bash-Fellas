extends AerialMovement

#private variables
var state_name = "Jump Squat"

var jump_timer := 0
@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	jump_timer += 1
	# Handle all states
	if not body.is_on_floor():
		state.update_state("Fall")
		return
	if animation_finished:
		state.update_state("Jump")
		return
	# Process inputs
	# Process physics
	pass

func reset(_delta):
	animation_finished = false
	can_crush = true
	jump_timer = 0
	pass
