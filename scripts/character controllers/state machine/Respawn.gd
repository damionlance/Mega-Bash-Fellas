extends AerialMovement

@onready var respawner := get_tree().get_current_scene().find_child("Respawner Handler")

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
	
	if Input.is_action_just_pressed("Jump"):
		state.update_state("Double Jump")
		return
	if Input.get_vector("Left", "Right", "Down", "Up") != Vector2.ZERO:
		state.update_state("Fall")
		return

func reset(_delta):
	body.velocity = Vector3.ZERO
	can_move = false
	await get_tree().create_timer(1.0).timeout
	respawner.respawn_entity(body, false)

func ready_to_move(body_name):
	if body_name == body.name:
		can_move = true
