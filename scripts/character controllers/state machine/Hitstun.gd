extends GroundedMovement

#private variables
var state_name = "Hitstun"
var hitlag_frames := 0
var wait_time := 100
var velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	if hitlag_frames == wait_time:
		body.velocity = velocity
		wait_time = 100
		if body.velocity.length() > 15.0:
			if body.is_on_floor():
				body.velocity.y *= -1
			state.update_state("Damage Fly")
			return
		elif not body.is_on_floor:
			state.update_state("Fall")
			return
		else:
			state.update_state("Idle")
		return
	hitlag_frames += 1

func reset(_delta):
	body.special = false
	body.attacking = false
	body.damaged = true
	hitlag_frames = 0
	velocity = body.velocity
	body.velocity = Vector3.ZERO
