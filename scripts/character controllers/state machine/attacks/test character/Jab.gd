extends GroundedMovement

class_name Default_Jab

#private variables
var state_name = "Jab"

var can_drop_thru_platform := false

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	# Process inputs
	await state.animation_finished
	state.update_state("Idle")
	# Handle all relevant timers
	
	# Process physics
	pass

func reset(_delta):
	pass
