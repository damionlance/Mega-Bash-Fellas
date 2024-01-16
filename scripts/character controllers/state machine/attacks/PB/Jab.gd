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
			if animation_finished:
				state.update_state("Idle")
				return
		2:
			if animation_finished and controller.attack_state == controller.attack_released:
				state.update_state("Idle")
				return
		1:
			if animation_finished:
				if controller.attack_state == controller.attack_held:
					state.update_state("Jab")
					current_jab = 3
					return
				state.update_state("Idle")
				current_jab = 0
				return
		_:
			if cancellable:
				if controller.attack_state == controller.attack_pressed:
					state.update_state("Jab")
					current_jab += 1
	
	
	# Handle all relevant timers
	
	# Process physics
	pass

func reset(_delta):
	cancellable = false
	animation_finished = false
