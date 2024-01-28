extends AerialMovement

#private variables
var state_name = "Damage Fly"
var hitlag_frames := 0
var wait_time := 100
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	var delta_v = Vector2.ZERO
	if hitlag_frames >= wait_time:
		
		body.apply_friction(constants.traction * 0.25)
		if body.is_on_floor():
			state.update_state("Landing Lag")
			return
	
	
	delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * Input.get_axis(state.player_number + "Left", state.player_number + "Right"))) * delta
	delta_v.y -= constants.gravity * delta
	body.delta_v = delta_v
	hitlag_frames += 1

func reset(_delta):
	body.special = false
	body.attacking = false
	hitlag_frames = 0
	wait_time = body.velocity.length()
