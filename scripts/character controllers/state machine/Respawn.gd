extends AerialMovement

class_name Respawn

@onready var respawner := $"../../../../Respawner Handler"

var can_move := false

#private variables
var state_name = "Respawn"

# Called when the node enters the scene tree for the first time.
func _ready():
	state.state_dictionary[state_name] = self
	respawner.respawn.connect(ready_to_move)

func update(delta):
	if not can_move:
		return
	
	if controller.attempting_jump:
		state.update_state("Double Jump")
		return
	if controller.movement_direction != Vector2.ZERO:
		state.update_state("Fall")
		return

func reset(_delta):
	body.velocity = Vector3.ZERO
	can_move = false
	await get_tree().create_timer(5.0).timeout
	respawner.respawn_entity(body, false)

func ready_to_move(body_name):
	if body_name == body.name:
		can_move = true
