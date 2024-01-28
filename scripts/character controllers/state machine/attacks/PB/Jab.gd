extends GroundedMovement

#private variables
var state_name = "Jab"

var can_drop_thru_platform := false

@export var cancellable := false
var current_jab := 0
@export var animation_finished := false

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	
	pass # Replace with function body.

func update(delta):
	
	# Process inputs
	match current_jab:
		3:
			if animation_finished and not Input.is_action_pressed(state.player_number + "Attack"):
				current_jab = 0
				state.update_state("Idle")
				return
		2:
			if animation_finished and not Input.is_action_pressed(state.player_number + "Attack") :
				current_jab = 0
				state.update_state("Idle")
				return
		1:
			if animation_finished:
				if Input.is_action_pressed(state.player_number + "Attack"):
					state.update_state("Jab")
					current_jab = 3
					return
				state.update_state("Idle")
				current_jab = 0
				return
			if cancellable:
				if Input.is_action_just_pressed(state.player_number + "Attack"):
					state.update_state("Jab")
					current_jab += 1
		_:
			if cancellable:
				if Input.is_action_just_pressed(state.player_number + "Attack"):
					state.update_state("Jab")
					current_jab += 1
			if animation_finished:
				state.update_state("Idle")
				current_jab = 0
				return
	
	
	# Handle all relevant timers
	
	# Process physics
	pass

func reset(_delta):
	body.attacking = true
	cancellable = false
	animation_finished = false
