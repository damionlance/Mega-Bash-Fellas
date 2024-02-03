extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	deactivate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if get_parent().state.current_state.state_name != "Down Special":
		deactivate()
		invisible()
	$mesh.rotation.y += 8 * PI * delta

func activate():
	$hitbox.active = true
	$hitbox2.active = true
	visible = true

func deactivate():
	$hitbox.active = false
	$hitbox2.active = false

func invisible():
	visible = false
