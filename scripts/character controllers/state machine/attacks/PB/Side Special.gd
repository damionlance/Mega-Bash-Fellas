extends AerialMovement


#private variables
var state_name = "Side Special"

var can_drop_thru_platform := false
var can_drift := false
var delta_time := 0.0166
var can_land := false
@export var active := false

@export var cancellable := false
@export var animation_finished := false

var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	if active and not can_land:
		body.velocity.x = constants.side_special_velocity * body.facing_direction * delta
		tween = get_tree().create_tween()
		tween.tween_property(body, "velocity", Vector3.ZERO, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	if animation_finished:
		state.update_state("Fall")
		return
	
	# Handle all relevant timers
	
	# Process physics
	pass

func reset(_delta):
	active = false
	can_land = false
	delta_time = _delta
	can_drift = false
	body.velocity = Vector3.ZERO
	body.special = true
	cancellable = false
	animation_finished = false
	pass

func interrupt():
	if tween != null:
		tween.stop()
		body.velocity.x = 0
	body.delta_v.x = 0
	state.update_state("Side Special Interrupt")
