extends Node3D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	global_position = get_parent().global_position
	global_position = global_position.clamp(-get_node("/root/Test Level").stage_size/2, get_node("/root/Test Level").stage_size/2)
