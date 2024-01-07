extends RayCast3D

@onready var body := get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		body.set_collision_mask_value(2, true)
	else:
		body.set_collision_mask_value(2, false)
