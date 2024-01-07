extends RayCast3D

@onready var body := get_parent()

var on_passthru_platform := false
var drop_thru := false
var fall_thru := false
var passthru_platform_timer : SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding() and not drop_thru and not fall_thru:
		print("Hello!")
		body.set_collision_mask_value(2, true)
		on_passthru_platform = true
	else:
		body.set_collision_mask_value(2, false)
		on_passthru_platform = false

func drop_thru_platform():
	drop_thru = true
	await get_tree().create_timer(1.0, true, false).timeout
	drop_thru = false
