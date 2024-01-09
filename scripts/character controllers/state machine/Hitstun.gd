extends GroundedMovement

class_name Hitstun

#private variables
var state_name = "Hitstun"
var hitstun_frames := 0
var wait_time := 100
var velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if hitstun_frames >= wait_time:
		body.velocity = velocity
		state.update_state("Idle")
		wait_time = 100
	hitstun_frames += 1

func reset(_delta):
	hitstun_frames = 0
	velocity = body.velocity
	body.velocity = Vector3.ZERO
