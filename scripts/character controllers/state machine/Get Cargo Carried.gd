extends AerialMovement


#private variables
var state_name = "Get Cargo Carried"

var can_drop_thru_platform := false
var can_dash := false
var grab_position
var cargo_carried := false
var difference := Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	# Process inputs
	# Handle all relevant timers
	# Process physics
	pass

func reset(_delta):
	body.damaged = true
	cargo_carried = false
	grab_position = Vector3.ZERO
	body.velocity = Vector3.ZERO
	body.delta_v = Vector2.ZERO
	body.attacking = false
	body.special = false
	can_drop_thru_platform = false
	body.consecutive_jumps = 0
	pass
