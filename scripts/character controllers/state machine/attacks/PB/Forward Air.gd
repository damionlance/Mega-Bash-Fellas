extends AerialMovement


#private variables
var state_name = "Fair"

var can_drop_thru_platform := false
var can_dash := false

@export var cancellable := false
@export var animation_finished := false
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	var delta_v = Vector2.ZERO
	
	if body.is_on_floor():
		state.update_state("Landing Lag")
	if animation_finished:
		state.update_state("Fall")
		return
	
	# Handle all relevant timers
	delta_v.y -= gravity * delta
	if body.velocity.y - delta_v.y < -falling_speed:
		delta_v.y = 0
	# Handle all relevant timers
	delta_v = regular_aerial_movement_processing(delta, delta_v)
	body.delta_v = delta_v
	# Process physics
	pass

func reset(_delta):
	body.attacking = true
	cancellable = false
	animation_finished = false
	pass
