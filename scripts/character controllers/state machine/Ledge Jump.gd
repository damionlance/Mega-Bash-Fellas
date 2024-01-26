extends AerialMovement

#private variables
var state_name = "Ledge Jump"

@export var animation_finished := false
@export var ledge_jump := false
var frame_one := false
var original_position
@onready var ledge_tracking := $"../../../Ledge Tracking/Climb Tracker"
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	if animation_finished == true:
		state.update_state("Idle")
		ledge_tracking.position = Vector3.ZERO
		return
	# Process inputs
	if ledge_jump:
		var delta_v = Vector2.ZERO
		if frame_one:
			body.velocity.y = constants.double_jump_force * delta
			frame_one = false
		if body.velocity.y <= 0:
			state.update_state("Fall")
			return
		
		delta_v.x = sign(controller.movement_direction.x) * (constants.base_air_acceleration + abs(constants.additional_air_acceleration * controller.movement_direction.x)) * delta
		
		delta_v.y -= constants.gravity * delta
		if body.velocity.y - delta_v.y < -constants.falling_speed:
			delta_v.y = 0
		
		regular_aerial_movement_processing(delta, delta_v)
		body.delta_v = delta_v
	else:
		body.global_position  = original_position + (ledge_tracking.position * Vector3(body.facing_direction, 1, 1))
	# Handle all relevant timers
	# Process physics

func reset(_delta):
	original_position = body.global_position
	animation_finished = false
	ledge_jump = false
	frame_one = true
