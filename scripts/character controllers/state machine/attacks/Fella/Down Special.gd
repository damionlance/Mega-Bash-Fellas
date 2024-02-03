extends AerialMovement


#private variables
var state_name = "Down Special"

var can_drop_thru_platform := false
var can_drift := false
var delta_time := 0.0166
var can_land := false
var aerial := false
var frame_one := false

@onready var shine := $"%Shine"

@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	if not frame_one:
		shine.deactivate()
	if Input.is_action_pressed(state.player_number + "Jump"):
		if body.is_on_floor():
			body.special = false
			state.update_state("Jump Squat")
			return
		if not body.is_on_floor() and body.can_jump:
			state.update_state("Double Jump")
			return
		return
	if not Input.is_action_pressed(state.player_number + "Special"):
		state.update_state("Idle")
		return
	# Handle all relevant timers
	# Handle all relevant timers
	delta_v.y -= constants.gravity * delta
	if body.velocity.y - delta_v.y < -constants.falling_speed:
		delta_v.y = 0
	body.delta_v = delta_v
	# Process physics
	frame_one = false
	pass

func reset(_delta):
	frame_one = true
	shine.activate()
	body.velocity = Vector3.ZERO
	can_land = false
	delta_time = _delta
	can_drift = false
	body.special = true
	animation_finished = false
	pass
