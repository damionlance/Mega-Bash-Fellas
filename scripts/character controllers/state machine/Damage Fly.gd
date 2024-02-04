extends AerialMovement

#private variables
var state_name = "Damage Fly"
var hitlag_frames := 0
var wait_time := 100
var tech_window = 0

var can_tech := true
var attempting_tech := false

var timer : Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	

func update(delta):
	var delta_v = Vector2.ZERO
	
	if body.is_on_floor() and Input.is_action_pressed(state.player_number + "Shield"):
		if Input.get_axis(state.player_number + "Left", state.player_number + "Right") == 0:
			state.update_state("Tech in Place")
			return
		else:
			state.update_state("Tech Roll")
			return
	
	if hitlag_frames >= wait_time:
		body.apply_friction(constants.traction * 0.25)
		if body.is_on_floor():
			state.update_state("Landing Lag")
			return
		else:
			state.update_state("Fall")
			body.damaged = false
			return
	delta_v.x = sign(Input.get_axis(state.player_number + "Left", state.player_number + "Right")) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * Input.get_axis(state.player_number + "Left", state.player_number + "Right"))) * delta
	delta_v.y -= constants.gravity * delta
	body.delta_v = delta_v
	hitlag_frames += 1

func reset(_delta):
	if timer != null:
		timer.queue_free()
	timer = Timer.new()
	add_child(timer)
	
	
	
	attempting_tech = false
	can_tech = true
	body.special = false
	body.attacking = false
	hitlag_frames = 0
	wait_time = body.velocity.length()


func attempt_tech():
	can_tech = false
	attempting_tech = true

