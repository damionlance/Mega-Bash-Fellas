extends AerialMovement

#private variables
var state_name = "Cargo Carry Jump Squat"

var jump_timer := 0
@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	# Handle all states
	if not body.is_on_floor():
		state.update_state("Cargo Carry Fall")
		return
	if animation_finished:
		state.update_state("Cargo Carry Jump")
		return
	state.grabbed_body.global_position = body.global_position
	state.grabbed_body.facing_direction = body.facing_direction
	pass

func reset(_delta):
	animation_finished = false
	can_crush = true
	jump_timer = 0
	pass
