extends Node3D

@onready var stage_root := get_tree().get_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_parent().global_position
	global_position = global_position.clamp(-stage_root.stage_size/2, stage_root.stage_size/2)
